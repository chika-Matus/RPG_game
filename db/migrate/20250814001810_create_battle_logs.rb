class CreateBattleLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :battle_logs do |t|
      t.references :player, null: false, foreign_key: true
      t.string :enemy_name, null: false, limit: 50
      t.boolean :victory, null: false
      t.integer :exp_gained, default: 0
      t.integer :player_level_before
      t.integer :player_level_after
      t.text :battle_summary  # デフォルト値を削除
      t.timestamps
    end
    
    add_index :battle_logs, :player_id
    add_index :battle_logs, :victory
    add_index :battle_logs, :created_at
  end
end
