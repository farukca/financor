class CreateFinancorInvoices < ActiveRecord::Migration
  def change
    create_table :financor_invoices do |t|
      t.string   :uuid, limit: 255, null: false
      t.string   :name, limit: 30, null: false
      t.integer  :company_id, null: false
      t.date     :invoice_date, null: false
      t.string   :invoice_type, null: false, limit: 20
      t.string   :debit_credit, null: false, limit: 10
      t.string   :curr, limit: 3, null: false
      t.decimal  :curr_rate, null: false
      t.decimal  :invoice_amount, null: false, default: 0
      t.decimal  :taxfree_amount, default: 0
      t.decimal  :taxed_amount, default: 0
      t.decimal  :tax_amount, default: 0
      t.decimal  :discount_rate, default: 0
      t.decimal  :discount_amount, default: 0
      t.integer  :payment_terms, default: 0
      t.date     :due_date
      t.string   :status, default: "active", limit: 10
      t.text     :notes, limit: 500
      t.string   :invoiced_type, limit: 30
      t.integer  :invoiced_id
      t.integer  :user_id, null: false
      t.integer  :patron_id, null: false
      t.string   :remote_id, limit: 255
      t.integer  :involines_count, default: 0
      t.integer  :comments_count, default: 0
      t.boolean  :trashed, default: false

      t.timestamps
    end
  end
end
