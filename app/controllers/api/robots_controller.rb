# frozen_string_literal: true

module Api
  # Robots controller
  class RobotsController < ApplicationController
    def index
      @robots = Robot.all
      render json: { robots: @robots }
    end

    def create
      robot = Robot.new(robot_params)
      robot.save
      render json: { robot: robot }, status: 200
    end

    def update; end

    def destroy; end

    def orders
      robot = Robot.find(params[:id])
      params[:commands].each do |command|
        break unless robot.read_command(command)
      end
      if robot.errors.present?
        render json: { message: 'error', errors: robot.errors.full_messages, status: 400 }, status: 400
      elsif robot.to_report == true
        render json: { message: 'success', location: [robot.x_position, robot.y_position, robot.facing] }, status: 200
      else
        render json: { message: 'success' }, status: 200
      end
    end

    private

    def robot_params
      params.permit(:commands, :x_position, :y_position, :facing)
    end
  end
end
