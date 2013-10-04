require 'spec_helper'

describe 'Web' do

  def app
    Sinatra::Application
  end

  describe 'index' do
    it 'returns http success' do
      get '/'
      expect(last_response).to be_ok
    end
  end

  describe 'gen' do
    it 'returns http success' do
      get '/gen/0000000000001000010000000/69cdbc'
      expect(last_response).to be_ok
    end
    it 'generates image' do
      get '/gen/0000000000001000010000000/69cdbc'
      expect(File.read('./tmp/images/0000000000001000010000000_69cdbc.png')).to eq(File.read('./spec/fixtures/0000000000001000010000000_69cdbc.png'))
    end
  end

end
