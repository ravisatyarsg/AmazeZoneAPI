class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :transaction_number
      t.integer :quantity
      t.decimal :total_cost, precision: 10, scale: 2
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :credit_card, null: false, foreign_key: true
      t.timestamps
    end
  end
end
