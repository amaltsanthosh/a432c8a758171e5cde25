# frozen_string_literal: true

require 'rails_helper'

# Change this ArticlesController to your project
RSpec.describe Api::RobotsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Article. As you add validations to Article, be sure to adjust the attributes here as well.
  let!(:robot) { create(:robot) }

  describe 'POST Robots#orders' do
    context 'Send commands and move bot' do
      it 'Places the bot and run the commands' do
        request.content_type = 'application/json'
        post :orders, params: { id: 1, commands: ['PLACE 0,0,NORTH', 'LEFT', 'REPORT'] }
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(response).to have_http_status(200)
        expect(json_response.values.flatten.count).to be == 4
        expect(json_response[:location]).to eq [0, 0, 'WEST']
      end
      it 'Places the bot and run the commands' do
        request.content_type = 'application/json'
        post :orders, params: { id: 1, commands: ['PLACE 0,0,NORTH', 'MOVE', 'REPORT'] }
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(response).to have_http_status(200)
        expect(json_response.values.flatten.count).to be == 4
        expect(json_response[:location]).to eq [0, 1, 'NORTH']
      end
      it 'Places the bot and run the commands' do
        request.content_type = 'application/json'
        post :orders, params: { id: 1, commands: ['PLACE 1,2,EAST', 'MOVE', 'MOVE', 'LEFT', 'MOVE', 'REPORT'] }
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(response).to have_http_status(200)
        expect(json_response.values.flatten.count).to be == 4
        expect(json_response[:location]).to eq [3, 3, 'NORTH']
      end
    end
    context 'move bot before place commands' do
      it 'neglects command before place' do
        request.content_type = 'application/json'
        post :orders, params: { id: 1, commands: ['LEFT', 'MOVE', 'PLACE 0,0,NORTH', 'MOVE', 'REPORT'] }
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(response).to have_http_status(200)
        expect(json_response.values.flatten.count).to be == 4
        expect(json_response[:location]).to eq [0, 1, 'NORTH']
      end
    end
    context 'place bot in falling position' do
      it 'returns error cannot place bot in falling position' do
        request.content_type = 'application/json'
        post :orders, params: { id: 1, commands: ['PLACE 6,0,NORTH', 'MOVE', 'REPORT'] }
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(response).to have_http_status(400)
        expect(json_response[:message]).to be == 'error'
        expect(json_response[:errors][0]).to be == 'Cannot place bot on falling position'
      end
    end
    context 'move bot to a falling position' do
      it 'returns error cannot place bot in falling position' do
        request.content_type = 'application/json'
        post :orders, params: { id: 1, commands: ['PLACE 3,0,NORTH', 'MOVE', 'MOVE', 'MOVE',
                                                  'MOVE', 'MOVE', 'MOVE', 'REPORT'] }
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(response).to have_http_status(400)
        expect(json_response[:message]).to be == 'error'
        expect(json_response[:errors][0]).to be == 'Cannot place bot on falling position'
      end
    end
  end
end
