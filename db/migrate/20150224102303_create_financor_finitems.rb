class CreateFinancorFinitems < ActiveRecord::Migration
  def change
    create_table :financor_finitems do |t|
      t.string     :code, limit: 255, null: false
      t.string     :name, limit: 255, null: false
      t.string     :item_type, limit: 50, null: false
      t.boolean    :salable, default: false
      t.decimal    :sales_price, default: 0
      t.string     :sales_curr, limit: 3
      t.integer    :sales_tax_id
      t.integer    :sales_account_id, index: true
      t.text       :sales_notes, limit: 1000
      t.boolean    :purchasable, default: false
      t.decimal    :purchase_price, default: 0
      t.string     :purchase_curr, limit: 3
      t.integer    :purchase_tax_id
      t.integer    :purchase_account_id, index: true
      t.text       :purchase_notes, limit: 1000
      t.boolean    :stockable, default: false
      t.string     :stock_unit, limit: 30
      t.integer    :min_stock_unit, default: 0
      t.references :patron, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :financor_finitems, :nimbos_patrons, column: :patron_id, primary_key: :id
    add_foreign_key :financor_finitems, :nimbos_users, column: :user_id, primary_key: :id
  end
end
