class AddAddressToInvoices < ActiveRecord::Migration
  def change
  	change_table :financor_invoices do |t|
  		t.string   :invoice_title, limit: 255
      t.string   :invoice_taxno, limit: 20
      t.string   :invoice_taxoffice, limit: 40
  		t.string   :invoice_country_id, limit: 2
  		t.string   :invoice_city, limit: 50
  		t.text     :invoice_address, limit: 255
      t.integer  :branch_id
  	end
  end
end
