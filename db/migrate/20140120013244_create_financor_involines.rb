class CreateFinancorInvolines < ActiveRecord::Migration
  def change
    create_table :financor_involines do |t|
      t.integer  :invoice_id
      t.integer  :company_id, null: false
      t.string   :name, limit: 255, null: false
      t.string   :debit_credit, null: false, limit: 10
      t.string   :line_type, limit: 30
      t.string   :curr, limit: 3, null: false
      t.decimal  :curr_rate, null: false, default: 1
      t.decimal  :invoice_rate, null: false, default: 1
      t.integer  :unit_number, default: 1
      t.string   :unit_type, limit: 20
      t.decimal  :unit_price, default: 0
      t.decimal  :total_amount, default: 0, null: false
      t.decimal  :discount_rate, default: 0
      t.decimal  :discount_amount, default: 0
      t.decimal  :vat_rate, default: 0
      t.decimal  :vat_amount, default: 0
      t.string   :vat_code, limit: 20
      t.decimal  :taxfree_amount, default: 0
      t.string   :notes, limit: 255
      t.integer  :user_id, null: false
      t.integer  :patron_id, null: false

      t.timestamps
    end
  end
end
