class CreateFinancorAccounts < ActiveRecord::Migration
  def change
    create_table :financor_accounts do |t|
      t.references :patron, index: true, null: false
      t.references :user, index: true, null: false
      t.string     :name, null: false, limit: 255
      t.references :parent, polymorphic: true, index: true
      t.string     :sales_account, limit: 50
      t.string     :purchase_account, limit: 50

      t.timestamps null: false
    end
    add_foreign_key :financor_accounts, :nimbos_patrons, column: :patron_id
    add_foreign_key :financor_accounts, :nimbos_users, column: :user_id
  end
end
