module Financor
  class Involine < ActiveRecord::Base
		
		attr_accessor :vat_status

    belongs_to :invoice#, counter_cache: true, touch: true
		belongs_to :company, class_name: Financor.company_class
	  belongs_to :user, class_name: Financor.user_class
	  #belongs_to :branch, class_name: Financor.branch_class


	  validates :name, presence: true, length: { maximum: 100 }
	  #validates :branch_id, :load_coun, :unload_coun, presence: true
	  #validates :debit_credit, presence: true
	  validates :curr, presence: true
	  validates :unit_number, numericality: { only_integer: true }
	  validates :unit_price, numericality: { greater_than: 0 }
	  #validates :total_amount, numericality: { greater_than: 0 }
	  validates :user_id, presence: true
	  validates :notes, length: { maximum: 500 }

	  default_scope { where(patron_id: Nimbos::Patron.current_id) }

    before_save :set_vat_amount 
	  after_save  :update_invoice
	  before_destroy :update_invoice_for_destroy

  	def self.invoice_unit_types
      %w[number day hour week year km]
    end

    def self.vat_statuses
    	%w[novat vatincluded excludedvat]
    end

    def set_invoice_values(invoice)
      self.company_id = invoice.company_id
      self.debit_credit = invoice.debit_credit
      self.curr_rate = 1.0
      self.invoice_rate = 1.0      
    end

    private

    def set_vat_amount
    	self.total_amount = self.unit_number * self.unit_price

    	if (vat_rate == 0) || (vat_status == "novat")
    	  #self.taxfree_amount = self.total_amount
    	  self.vat_amount     = 0
    	else
        #self.taxfree_amount = 0
        if self.vat_status == "vatincluded"
        	self.vat_amount   = total_amount - (total_amount / (1 + (vat_rate / 100)))
        else
        	self.vat_amount   = (total_amount * vat_rate) / 100
        end
    	  
    	end
    end

    def update_invoice
    	if total_amount_changed? || vat_amount_changed? || vat_rate_changed?
	    	invoice = self.invoice

	    	#subtract old values
	    	invoice.invoice_amount   = invoice.invoice_amount - total_amount_was
	    	invoice.tax_amount       = invoice.tax_amount - vat_amount_was
	    	if vat_rate_was == 0
	    	  invoice.taxfree_amount = invoice.taxfree_amount - total_amount_was
	    	else
	    	  invoice.taxed_amount   = invoice.taxed_amount - total_amount_was
	    	end

	    	#add new amounts
	    	invoice.invoice_amount   = invoice.invoice_amount + total_amount
	    	invoice.tax_amount       = invoice.tax_amount + vat_amount
	    	if vat_rate == 0
	    	  invoice.taxfree_amount = invoice.taxfree_amount + total_amount
	    	else
	    	  invoice.taxed_amount   = invoice.taxed_amount + total_amount
	    	end

    	  if id_changed?
    		  invoice.involines_count += 1
    	  end
      	invoice.save!	    	
      end
    end

    def update_invoice_for_destroy
      invoice = self.invoice

	    #subtract old values
	    invoice.invoice_amount   = invoice.invoice_amount - total_amount
	    invoice.tax_amount       = invoice.tax_amount - vat_amount
	    if vat_rate == 0
	      invoice.taxfree_amount = invoice.taxfree_amount - total_amount
	    else
	      invoice.taxed_amount   = invoice.taxed_amount - total_amount
	    end
      invoice.save!

    end

  end
end
