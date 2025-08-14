# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_14_001825) do
  create_table "battle_logs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.string "enemy_name"
    t.boolean "victory"
    t.integer "exp_gained"
    t.integer "player_level_before"
    t.integer "player_level_after"
    t.text "battle_summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_battle_logs_on_player_id"
  end

  create_table "enemies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "base_hp"
    t.integer "base_attack"
    t.integer "base_defense"
    t.integer "exp_reward"
    t.integer "min_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "game_sessions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.text "battle_log"
    t.boolean "in_battle"
    t.text "current_enemy_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_game_sessions_on_player_id"
  end

  create_table "players", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "level"
    t.integer "hp"
    t.integer "max_hp"
    t.integer "attack"
    t.integer "defense"
    t.integer "exp"
    t.integer "exp_to_next"
    t.integer "battle_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "battle_logs", "players"
  add_foreign_key "game_sessions", "players"
end
