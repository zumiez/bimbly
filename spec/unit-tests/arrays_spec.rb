require 'webmock/rspec'
require 'rspec'
require_relative '../../lib/nimble_provisions'

describe NimbleProvisions do
  before :all do
    @nimble = NimbleProvisions.new
#    @device = JSON.parse(File.read("#{File.dirname(__FILE__)}/support/fixtures/device.json"))
#    @devices = JSON.parse(File.read("#{File.dirname(__FILE__)}/support/fixtures/devices.json"))
#    @network = JSON.parse(File.read("#{File.dirname(__FILE__)}/support/fixtures/network.json"))
#    @networks = JSON.parse(File.read("#{File.dirname(__FILE__)}/support/fixtures/networks.json"))
  end

  describe '::createACR' do
    it 'should create an Access Control Record' do

    begin=
      it 'should grab a device from a given network and serial' do
        dev = @device
        allow(@meraki).to receive(:get_device).and_return(dev)

        response = @meraki.get_device(network_id: :net_id, serial: :serial)

        expect(response).to eq dev
    end=

    

    
    end
  end

  describe '::readACR' do
    it 'should retrieve the Access Control Records' do



    end
  end

  describe '::deleteACR' do
    it 'should delete an Access Control Record' do

    

    end
  end
end
