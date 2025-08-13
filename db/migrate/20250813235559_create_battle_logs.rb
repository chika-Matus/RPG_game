class CreateBattleLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :game_sessions do |t|
      t.references :player, null: false, foreign_key: true
      t.text :battle_log, default: ""
      t.boolean :in_battle, default: false
      t.json :current_enemy
      t.timestamps
    end
  end
end
