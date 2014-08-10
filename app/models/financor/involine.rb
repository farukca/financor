module Financor
  class Involine < ActiveRecord::Base
		
		attr_accessor :vat_id, :vat_status, :isfrom

    belongs_to :invoice#, counter_cache: true, touch: true
		belongs_to :company, class_name: Financor.company_class
	  belongs_to :user, class_name: Financor.user_class
	  #belongs_to :branch, class_name: Financor.branch_class

	  validates :name, presence: true, length: { maximum: 255 }
	  #validates :branch_id, :load_coun, :unload_coun, presence: true
	  validates :debit_credit, presence: true, length: { maximum: 10 }
	  validates :curr, presence: true, length: { maximum: 3 }
	  validates :unit_number, numericality: { only_integer: true }
	  validates :unit_price, numericality: { greater_than: 0 }
	  validates :total_amount, numericality: { greater_than: 0 }
	  #validates :user_id, presence: true
	  validates :notes, length: { maximum: 255 }
    validates :line_type, length: { maximum: 30 }
    #validates :curr_rate, numericality: true
    validates :invoice_rate, numericality: true
    validates :unit_type, length: { maximum: 20 }
    #validates :discount_rate, numericality: true
    #validates :discount_amount, numericality: { greater_than: 0 }
    validates :vat_rate, numericality: true
    validates :vat_amount, numericality: true
    validates :taxfree_amount, numericality: true
    #validates_associated :invoice
    #validates_associated :company

	  default_scope { where(patron_id: Nimbos::Patron.current_id) }

    #before_save :calculate_total
    before_validation :set_calculations, :if => Proc.new { |involine| involine.isfrom == "manuel" }
    before_update  :set_calculations
    after_create   :update_invoice, :if => Proc.new { |involine| involine.isfrom == "manuel" }
	  after_update   :update_invoice
	  before_destroy :update_invoice_for_destroy

  	def self.invoice_unit_types
      %w[number day hour week year km]
    end

    def set_invoice_values(invoice)
      self.company_id   = invoice.company_id
      self.debit_credit = invoice.debit_credit
      self.curr         = invoice.curr
      self.curr_rate    = 1.0
      self.invoice_rate = 1.0
    end

    def calculate_total
      set_calculations
    end

    def self.search(search_id)
      search = Roster::Search.find(search_id)
      involines = Financor::Involine.order(:created_at, :desc)
      involines = involines.where("name like ?", "%#{search.filter["name"]}%") if search.filter["name"].present?
      #involines = involines.where(invoice_date: search.filter["docdate1"]..search.filter["docdate2"]) if search.filter["docdate1"].present?
      involines = involines.where(company_id: search.filter["company_id"]) if search.filter["company_id"].present?
      involines = involines.where(debit_credit: search.filter["debit_credit"]) if search.filter["debit_credit"].present?
      involines = involines.where(curr: search.filter["curr"]) if search.filter["curr"].present?
      involines
    end

    private

    def set_calculations
    	self.total_amount = self.unit_number * self.unit_price

    	if self.vat_id.present?
        tax = Taxcode.find(self.vat_id)
        self.vat_rate       = tax.rate
        #if self.vat_status == "vatincluded"
        #  self.vat_amount   = self.total_amount - (self.total_amount / (1 + (self.vat_rate / 100)))
        #else
          self.vat_amount   = (self.total_amount * self.vat_rate) / 100
        #end
    	else
        self.vat_amount     = 0
        self.vat_rate       = 0
    	end
    end

    def update_invoice
    	if self.total_amount_changed? || self.vat_amount_changed? || self.vat_rate_changed?
	    	invoice = self.invoice

	    	#subtract old values
	    	invoice.invoice_amount   -= self.total_amount_was
        invoice.invoice_amount   -= self.vat_amount_was
	    	invoice.tax_amount       -= self.vat_amount_was
	    	if vat_rate_was == 0
	    	  invoice.taxfree_amount -= self.total_amount_was
	    	else
	    	  invoice.taxed_amount   -= self.total_amount_was
	    	end

	    	#add new amounts
	    	invoice.invoice_amount   += self.total_amount
        invoice.invoice_amount   += self.vat_amount
	    	invoice.tax_amount       += self.vat_amount
	    	if vat_rate == 0
	    	  invoice.taxfree_amount += self.total_amount
	    	else
	    	  invoice.taxed_amount   += self.total_amount
	    	end

      	invoice.save
      end
    end

    def update_invoice_for_destroy
      invoice = self.invoice

	    #subtract old values
	    invoice.invoice_amount   -= self.total_amount
      invoice.invoice_amount   -= self.vat_amount
	    invoice.tax_amount       -= self.vat_amount
	    if vat_rate == 0
	      invoice.taxfree_amount -= self.total_amount
	    else
	      invoice.taxed_amount   -= self.total_amount
	    end
      invoice.save

    end

  end
end
