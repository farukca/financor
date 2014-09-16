class CreateFinancorCurrencyRates < ActiveRecord::Migration
  def change
    create_table :financor_currency_rates do |t|
      t.string   :bank, null: false
      t.date     :rate_date, null: false
      t.integer  :unit, default: 1
      t.string   :curr, null: false, limit: 3
      t.string   :bank_curr, null: false, limit: 3
      t.decimal  :buying, precision: 10, scale: 5
      t.decimal  :selling, precision: 10, scale: 5
      t.decimal  :banknote_buying, precision: 10, scale: 5
      t.decimal  :banknote_selling, precision: 10, scale: 5
      t.decimal  :usd_rate, precision: 10, scale: 5

      t.timestamps
    end

    add_index :financor_currency_rates, [:bank, :rate_date, :curr, :bank_curr], unique: true, name: "unique_on_bank_date_and_currencies"
  end
end
