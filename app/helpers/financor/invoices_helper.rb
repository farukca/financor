module Financor
  module InvoicesHelper

  	def invoice_amount_without_taxes(invoice=@invoice)
  		invoice.taxfree_amount + invoice.taxed_amount
  	end
  end
end
