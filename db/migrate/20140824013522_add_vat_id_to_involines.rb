class AddVatIdToInvolines < ActiveRecord::Migration
  def change
  	change_table :financor_involines do |t|
  		t.integer  :vat_id
  	end
  end
end
