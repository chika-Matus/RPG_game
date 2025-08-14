class Enemy < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 500 }
  validates :base_hp, :base_attack, :base_defense, :exp_reward, :min_level, 
            presence: true, numericality: { greater_than: 0 }
  
  def self.random_for_player(player)
    suitable_enemies = where('min_level <= ?', player.level)
    suitable_enemies = where(min_level: 1) if suitable_enemies.empty?
    suitable_enemies.sample
  end
  
  def generate_instance(player_level)
    level_multiplier = 1 + (player_level - 1) * 0.1
    
    {
      'name' => name,
      'description' => description,
      'hp' => (base_hp * level_multiplier).to_i,
      'max_hp' => (base_hp * level_multiplier).to_i,
      'attack' => (base_attack * level_multiplier).to_i,
      'defense' => (base_defense * level_multiplier).to_i,
      'exp_reward' => (exp_reward * level_multiplier).to_i
    }
  end
end
