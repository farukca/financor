class AddIndexesToFinancorInvoices < ActiveRecord::Migration
  def change
  	add_index :financor_invoices, :patron_id
  	add_index :financor_invoices, :company_id
  	add_index :financor_invoices, :debit_credit
  	add_index :financor_invoices, [:invoiced_type, :invoiced_id]
  	add_index :financor_invoices, :branch_id
  end
end
