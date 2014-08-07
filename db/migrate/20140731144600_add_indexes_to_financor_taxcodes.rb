class AddIndexesToFinancorTaxcodes < ActiveRecord::Migration
  def change
  	add_index :financor_taxcodes, :patron_id
  end
end
