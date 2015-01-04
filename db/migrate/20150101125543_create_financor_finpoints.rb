class CreateFinancorFinpoints < ActiveRecord::Migration
  def change
    create_table :financor_finpoints do |t|
      t.string   :title, limit: 100, null: false
      t.string   :point_type, limit: 30, null: false
      t.string   :curr, limit: 3
      t.string   :reference, limit: 50
      t.string   :bank, limit: 100
      t.references :branch, index: true
      t.references :manager, index: true
      t.references :patron, index: true, null: false

      t.timestamps
    end
  end
end
