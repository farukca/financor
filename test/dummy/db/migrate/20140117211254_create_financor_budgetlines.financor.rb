# This migration comes from financor (originally 20140115204224)
class CreateFinancorBudgetlines < ActiveRecord::Migration
  def change
    create_table :financor_budgetlines do |t|
      t.string   :name, null: false, limit: 255
      t.string   :line_type, limit: 20, null: false
      t.integer  :company_id
      t.decimal  :amount, default: 0
      t.string   :curr, null: false, limit: 3
      t.string   :item_type, limit: 30
      t.string   :budgeted_type, limit: 100
      t.integer  :budgeted_id
      t.string   :status, limit: 10, default: "active"
      t.text     :notes, limit: 500
      t.integer  :user_id, null: false
      t.integer  :patron_id, null: false

      t.timestamps
    end
  end
end
