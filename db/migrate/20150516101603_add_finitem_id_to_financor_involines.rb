class AddFinitemIdToFinancorInvolines < ActiveRecord::Migration
  def change
  	change_table   :financor_involines do |t|
  		t.references :finitem, index: true
  	end
  	add_foreign_key :financor_involines, :financor_finitems, column: :finitem_id
  end
end
