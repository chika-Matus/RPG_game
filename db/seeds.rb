# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# 敵データの初期設定
Enemy.create!([
  {
    name: "スライム",
    description: "ぷるぷると震える青いスライム。初心者向けの敵。",
    base_hp: 20,
    base_attack: 8,
    base_defense: 2,
    exp_reward: 25,
    min_level: 1
  },
  {
    name: "ゴブリン",
    description: "鋭い爪を持つ緑の小鬼。素早い動きで攻撃してくる。",
    base_hp: 35,
    base_attack: 12,
    base_defense: 4,
    exp_reward: 40,
    min_level: 2
  },
  {
    name: "オーク",
    description: "巨大な斧を振り回す獰猛な戦士。高い攻撃力を持つ。",
    base_hp: 60,
    base_attack: 18,
    base_defense: 8,
    exp_reward: 70,
    min_level: 4
  },
  {
    name: "ドラゴン",
    description: "炎を吐く伝説の竜。最強クラスの敵。",
    base_hp: 120,
    base_attack: 25,
    base_defense: 15,
    exp_reward: 150,
    min_level: 7
  }
])

puts "敵データを作成しました！"