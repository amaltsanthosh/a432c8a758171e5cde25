# frozen_string_literal: true

# Robot class
class Robot < ApplicationRecord
  attr_accessor :is_placed, :to_report
  validate :validate_position

  DIRECTIONS = %w[EAST SOUTH WEST NORTH].freeze

  def validate_position
    return unless x_position.negative? || y_position.negative? || x_position > max_x || y_position > max_y

    errors.add(:base, 'Cannot place bot on falling position')
  end

  def read_command(command)
    if command.split(' ').first == 'PLACE'
      place_robot(command)
    elsif is_placed
      execute_command(command)
    else
      true
    end
  end

  def place_robot(command)
    placing_coordinates = command.split(/[\s\,]/)[1..3]
    self.is_placed = true
    update_attributes(x_position: placing_coordinates.first.to_i,
                      y_position: placing_coordinates.second.to_i,
                      facing: placing_coordinates.last)
  end

  def execute_command(command)
    coordinates = { 'NORTH' => :y_position, 'SOUTH' => :y_position, 'EAST' => :x_position, 'WEST' => :x_position }
    movements = { 'NORTH' => 1, 'SOUTH' => -1, 'EAST' => 1, 'WEST' => -1 }
    index = DIRECTIONS.index(facing)
    case command
    when 'MOVE'
      update_attributes(coordinates[facing] => instance_eval(coordinates[facing].to_s) + movements[facing])
    when 'LEFT'
      update_attributes(facing: DIRECTIONS[(index - 1) % 4])
    when 'RIGHT'
      update_attributes(facing: DIRECTIONS[(index + 1) % 4])
    when 'REPORT'
      self.to_report = true
    end
  end
end
