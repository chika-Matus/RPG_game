class CreateGameSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :game_sessions do |t|
      t.references :player, null: false, foreign_key: true
      t.text :battle_log  # デフォルト値を削除
      t.boolean :in_battle, default: false
      t.json :current_enemy  # デフォルト値を削除
      t.timestamps
    end
    
    add_index :game_sessions, :player_id, unique: true
  end
end
