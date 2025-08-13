class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :name, null: false
      t.integer :level, default: 1
      t.integer :hp, null: false
      t.integer :max_hp, null: false
      t.integer :attack, null: false
      t.integer :defense, null: false
      t.integer :exp, default: 0
      t.integer :exp_to_next, null: false
      t.integer :battle_count, default: 0
      t.timestamps
    end
  end
end
