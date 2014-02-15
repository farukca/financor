class CreateFinancorTaxcodes < ActiveRecord::Migration
  def change
    create_table :financor_taxcodes do |t|
      t.string   :name, null: false, limit: 40
      t.float    :rate, default: 0
      t.string   :code, null: false, limit: 40
      t.integer  :patron_id, null: false
      t.integer  :user_id, null: false

      t.timestamps
    end
  end
end
