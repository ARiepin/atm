require 'rails_helper'

RSpec.describe 'ATM management', type: :request do
  describe '#deposit' do
    context 'with valid denominations' do
      it 'puts money into ATM' do
        headers = { "CONTENT_TYPE" => "application/json" }
        post '/api/v1/notes/deposit', params: '{ "notes": { "25":"10", "50":"10" } }', headers: headers

        expect(response.content_type).to eq("application/json")
        expect(response).to be_success
      end
    end

    context 'with invalid denomiantions' do
      it 'raises validation error' do
        headers = { "CONTENT_TYPE" => "application/json" }
        post "/api/v1/notes/deposit", params: '{ "notes": { "25":"10", "51":"10" } }', headers: headers

        expect(response.status).to eq(422)
      end
    end
  end

  describe '#withdraw' do
    before do
      Note::AVAILABLE_DENOMINATIONS.each {|el| 10.times {Note.create!(denomination: el)}}
    end

    context 'with enough money in ATM' do
      it 'gets money' do
        headers = { "CONTENT_TYPE" => "application/json" }
        get '/api/v1/notes/withdraw', params: { amount: 920 }, headers: headers

        expect(response).to be_success
      end
    end

    context 'with not enough money in ATM' do
      it 'raises error' do
        headers = { "CONTENT_TYPE" => "application/json" }
        get '/api/v1/notes/withdraw', params: { amount: 940 }, headers: headers
        body = JSON.parse(response.body)

        expect(response.status).to eq(422)
        expect(body['error']).to eq('Unable to proceed. Please specify another amount')
      end
    end

    context 'with not enough notes of specific denomination in ATM' do
      before { 10.times{ Note.first.delete } }

      it 'raises error' do
        headers = { "CONTENT_TYPE" => "application/json" }
        get '/api/v1/notes/withdraw', params: { amount: 919 }, headers: headers
        body = JSON.parse(response.body)

        expect(response.status).to eq(422)
        expect(body['error']).to eq('Unable to proceed. Please specify another amount')
      end
    end
  end
end
