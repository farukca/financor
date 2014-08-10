class AddIndexesToFinancorInvolines < ActiveRecord::Migration
  def change
  	add_index :financor_involines, :patron_id
  	add_index :financor_involines, :invoice_id
  	add_index :financor_involines, :company_id
  end
end
