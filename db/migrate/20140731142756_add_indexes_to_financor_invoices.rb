class AddIndexesToFinancorInvoices < ActiveRecord::Migration
  def change
  	add_index :financor_invoices, :patron_id
  	add_index :financor_invoices, [:name, :patron_id]
  	add_index :financor_invoices, [:company_id, :patron_id]
  	add_index :financor_invoices, [:debit_credit, :patron_id]
  	add_index :financor_invoices, [:invoiced_type, :invoiced_id]
  	add_index :financor_invoices, [:invoice_title, :patron_id]
  	add_index :financor_invoices, [:branch_id, :patron_id]
  end
end
