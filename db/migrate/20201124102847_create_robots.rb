# frozen_string_literal: true

# Create robots
class CreateRobots < ActiveRecord::Migration[5.0]
  def change
    create_table :robots do |t|
      t.integer :x_position, default: 0
      t.integer :y_position, default: 0
      t.integer :max_x, default: 5
      t.integer :max_y, default: 5
      t.string :facing
      t.timestamps
    end
  end
end
