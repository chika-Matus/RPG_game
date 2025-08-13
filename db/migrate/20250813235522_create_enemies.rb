class CreateEnemies < ActiveRecord::Migration[8.0]
  def change
    create_table :enemies do |t|
      t.string :name, null: false
      t.text :description
      t.integer :base_hp, null: false
      t.integer :base_attack, null: false
      t.integer :base_defense, null: false
      t.integer :exp_reward, null: false
      t.integer :min_level, default: 1
      t.timestamps
    end
  end
end
