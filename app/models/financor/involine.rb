module Financor
  class Involine < ActiveRecord::Base
		
		attr_accessor :vat_id, :vat_status, :isfrom

    belongs_to :invoice#, counter_cache: true, touch: true
		belongs_to :company, class_name: Financor.company_class
	  belongs_to :user, class_name: Financor.user_class
	  #belongs_to :branch, class_name: Financor.branch_class


	  validates :name, presence: true, length: { maximum: 100 }
	  #validates :branch_id, :load_coun, :unload_coun, presence: true
	  #validates :debit_credit, presence: true
	  #validates :curr, presence: true
	  validates :unit_number, numericality: { only_integer: true }
	  validates :unit_price, numericality: { greater_than: 0 }
	  #validates :total_amount, numericality: { greater_than: 0 }
	  #validates :user_id, presence: true
	  validates :notes, length: { maximum: 500 }

	  default_scope { where(patron_id: Nimbos::Patron.current_id) }

    #before_save :calculate_total
    before_create  :set_calculations, :if => Proc.new { |involine| involine.isfrom == "manuel" }
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

      	invoice.save!	    	
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
      invoice.save!

    end

  end
end
