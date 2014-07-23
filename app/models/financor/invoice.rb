module Financor
  class Invoice < ActiveRecord::Base

		belongs_to :company, class_name: Financor.company_class
	  belongs_to :user, class_name: Financor.user_class
    belongs_to :invoiced, polymorphic: true, touch: true#, counter_cache: true
	  belongs_to :branch, class_name: Financor.branch_class

  	has_many   :involines
	  accepts_nested_attributes_for :involines, :reject_if => proc { |a| a[:name].blank? }

	  has_many :comments, class_name: Financor.comment_class, as: :commentable, dependent: :destroy

    attr_accessor :invoice_financial_id

	  validates :name, presence: true, length: { maximum: 30 }
    validates :name, uniqueness: { case_sensitive: false, scope: :patron_id }, if: Proc.new { |a| (a.debit_credit == "debit") }
    validates :invoice_title, presence: true, length: { maximum: 255 }
	  validates :company_id, presence: true
    validates :invoice_date, presence: true
	  validates :invoice_type, presence: true, length: { maximum: 20 }
	  validates :debit_credit, presence: true, length: { maximum: 10 }
	  validates :curr, presence: true, length: { maximum: 3 }
    #validates :curr_rate, numericality: true
	  validates :user_id, presence: true
	  validates :notes, length: { maximum: 500 }
    validates :invoice_amount, numericality: true
    validates :taxfree_amount, numericality: true
    validates :taxed_amount, numericality: true
    validates :tax_amount, numericality: true
    #validates :discount_rate, numericality: true
    #validates :discount_amount, numericality: true
    validates :due_date, presence: true
    validates :status, inclusion: { in: %w(active confirmed cancelled) }
    
    #validates_associated :company

	  default_scope { where(patron_id: Nimbos::Patron.current_id) }
	  scope :active, where(status: "active")

    before_validation :set_invoice_lines
  	before_create :generate_uuid
    after_create  :set_company_financial

  	def self.invoice_status
      %w[active confirmed cancelled]
    end

  	def self.debit_credit_types
      %w[debit credit]
    end

  	def self.invoice_types
      %w[refundable nonrefund]
    end

    def self.search(search_id)
      search = Roster::Search.find(search_id)
      invoices = Financor::Invoice.order(:name)
      invoices = invoices.where("name like ?", "%#{search.filter["name"]}%") if search.filter["name"].present?
      invoices = invoices.where(invoice_date: search.filter["docdate1"]..search.filter["docdate2"]) if search.filter["docdate1"].present?
      invoices = invoices.where(due_date: search.filter["due_date1"]..search.filter["due_date2"]) if search.filter["due_date1"].present?
      invoices = invoices.where(company_id: search.filter["company_id"]) if search.filter["company_id"].present?
      invoices = invoices.where(debit_credit: search.filter["debit_credit"]) if search.filter["debit_credit"].present?
      invoices = invoices.where(curr: search.filter["curr"]) if search.filter["curr"].present?
      invoices
    end

		private
  	def generate_uuid
  		self.uuid = Time.now.to_i.to_s
  		self.curr_rate = 1
  	end

    def set_invoice_lines
      self.involines.each do |line|
        line.user_id      = self.user_id
        line.company_id   = self.company_id
        line.debit_credit = self.debit_credit
        line.curr         = self.curr
        line.curr_rate    = 1.0
        line.invoice_rate = 1.0

        line.calculate_total
        
        #add new amounts
        self.tax_amount       += line.vat_amount
        if line.vat_rate == 0
          self.taxfree_amount += line.total_amount
        else
          self.taxed_amount   += line.total_amount
        end
        self.invoice_amount   += line.total_amount
        self.invoice_amount   += line.vat_amount

        self.involines_count  += 1
      end
    end

    def set_company_financial
      if self.invoice_financial_id.blank?
        financial_info = self.company.financial
        unless financial_info
          self.company.create_financial(title: self.invoice_title, taxno: self.invoice_taxno, taxoffice: self.invoice_taxoffice, invoice_country_id: self.invoice_country_id, invoice_city: self.invoice_city, invoice_address: self.invoice_address, user_id: self.user_id)
        end
      end
    end
  	
  end
end
