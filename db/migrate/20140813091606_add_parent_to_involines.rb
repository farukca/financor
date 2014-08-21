class AddParentToInvolines < ActiveRecord::Migration
  def change
  	change_table   :financor_involines do |t|
  		t.references :parent, polymorphic: true, index: true
  	end
  end
end
