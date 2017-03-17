require 'webmock/rspec'
require 'rspec'
require_relative '../../lib/nimble_provisions'

describe "NimbleProvisions" do
  before :all do
    @nimble = NimbleProvisions.new
    @volume = JSON.parse(File.read("#{File.dirname(__FILE__)}/../support/fixtures/volume.json"))
    @volume_detail = JSON.parse(File.read(
                                 "#{File.dirname(__FILE__)}/../support/fixtures/volume.json"))
    @volumes = JSON.parse(File.read("#{File.dirname(__FILE__)}/../support/fixtures/volumes.json"))
    @volumes_detail = JSON.parse(File.read(
                              "#{File.dirname(__FILE__)}/../support/fixtures/volumes_detail.json"))
  end

=begin
describe MerakiProvisions do
  fixtures = "#{File.dirname(__FILE__)}/../support/fixtures"    

  before :all do
    @meraki = MerakiProvisions.new
    @network = File.read("#{fixtures}/network.json")
    @networks = File.read("#{fixtures}/networks.json")
    @uplinks = File.read("#{fixtures}/uplinks.json")
    @serial = File.read("#{fixtures}/serial.json")
    @s2sVPN = File.read("#{fixtures}/s2sVPN.json")
  end

  describe '#getNetwork' do
    context 'when network id is valid' do      
      it 'responds with 200 ' do
        response = double

        allow(response).to receive(:code).and_return( 200 )
        allow(@meraki).to receive(:get_network).and_return( response )
        
        rep = @meraki.get_network(network_id: :good_id)

        expect(rep.code).to eq 200
      end

      it 'retrieves a valid json object of a network' do
        response = double
        
        allow(response).to receive(:body).and_return( @network )
        allow(@meraki).to receive(:get_network).and_return( response )        
        rep = @meraki.get_network(network_id: :good_id)

        expect(@meraki.valid_json?(rep.body)).to eq true
        expect(rep.body).to eq @network
      end
    end

    context 'when network id is invalid' do
      it 'responds with 404 code' do
        response = double

        allow(response).to receive(:code) { 404 }
        allow(@meraki).to receive(:get_network).and_return( response )
        
        rep = @meraki.get_network(network_id: :bad_id)

        expect(rep.code).to eq 404
      end
    end

    context 'when called without providing network id' do
      it 'responds with ArgumentError' do
        expect { @meraki.get_network() }.to raise_exception(ArgumentError)
        expect { @meraki.get_network(network_id: :id) }.to_not raise_exception
      end
    end
  end
=end

=begin
  decscribe '#createVolume' do
    context 'when sent a valid request' do
      it 'should create a volume' do
        volume = @volume
        allow(@nimble).to receive(:create_volume).and_return()

        response = @meraki.create_volume()

        expect(response).to eq volume
      end
    end

    context 'when network id is valid' do      
      it 'responds with 200 ' do
        response = double

        allow(response).to receive(:code).and_return( 200 )
        allow(@meraki).to receive(:get_network).and_return( response )
        
        rep = @meraki.get_network(network_id: :good_id)

        expect(rep.code).to eq 200
      end

      it 'retrieves a valid json object of a network' do
        response = double
        
        allow(response).to receive(:body).and_return( @network )
        allow(@meraki).to receive(:get_network).and_return( response )        
        rep = @meraki.get_network(network_id: :good_id)

        expect(@meraki.valid_json?(rep.body)).to eq true
        expect(rep.body).to eq @network
      end
    end
    
    context 'when sent an invalid request' do
      it 'should return a ___ error' do

      end
    end
  end
  
=end

  describe '#getVolumes' do
    context 'when request id is valid' do      
      it 'responds with 200 ' do
        response = double

        allow(response).to receive(:code).and_return( 200 )
        allow(@nimble).to receive(:get_network).and_return( response )
        
        rep = @nimble.get_volumes(network_id: :good_id)

        expect(rep.code).to eq 200
      end

      it 'retrieves a valid json object of a network' do
        response = double
        
        allow(response).to receive(:body).and_return( @network )
        allow(@meraki).to receive(:get_network).and_return( response )        
        rep = @meraki.get_network(network_id: :good_id)

        expect(@meraki.valid_json?(rep.body)).to eq true
        expect(rep.body).to eq @network
      end
    end

    context 'when network id is invalid' do
      it 'responds with 404 code' do
        response = double

        allow(response).to receive(:code) { 404 }
        allow(@meraki).to receive(:get_network).and_return( response )
        
        rep = @meraki.get_network(network_id: :bad_id)

        expect(rep.code).to eq 404
      end
    end

    context 'when called without providing network id' do
      it 'responds with ArgumentError' do
        expect { @meraki.get_network() }.to raise_exception(ArgumentError)
        expect { @meraki.get_network(network_id: :id) }.to_not raise_exception
      end
    end
  end
    
  describe '#getVolumeById' do
    context 'when network id is valid' do      
      it 'responds with 200 ' do
        response = double

        allow(response).to receive(:code).and_return( 200 )
        allow(@meraki).to receive(:get_networks).and_return( response )
        
        rep = @meraki.get_networks()

        expect(rep.code).to eq 200
      end

      it 'retrieves a valid json object with array of networks' do
        response = double
        
        allow(response).to receive(:body).and_return( @networks )
        allow(@meraki).to receive(:get_networks).and_return( response )        
        rep = @meraki.get_networks()

        expect(@meraki.valid_json?(rep.body)).to eq true
        expect(rep.body).to eq @networks
      end
    end
  end

  describe '::restoreVolume' do
    it 'should restore a volume from a snapshot' do
      
    end
  end

  describe '::updateVolume' do
    it 'should restore a volume from a snapshot' do

    end
  end

  
  describe '::deleteVolume' do
    it 'should remove a volume' do

         

    end
  end
end

=begin
require 'webmock/rspec'
require 'rspec'
require_relative '../../lib/meraki_provisions'

describe MerakiProvisions do
  fixtures = "#{File.dirname(__FILE__)}/../support/fixtures"    

  before :all do
    @meraki = MerakiProvisions.new
    @network = File.read("#{fixtures}/network.json")
    @networks = File.read("#{fixtures}/networks.json")
    @uplinks = File.read("#{fixtures}/uplinks.json")
    @serial = File.read("#{fixtures}/serial.json")
    @s2sVPN = File.read("#{fixtures}/s2sVPN.json")
  end

  describe '#getNetwork' do
    context 'when network id is valid' do      
      it 'responds with 200 ' do
        response = double

        allow(response).to receive(:code).and_return( 200 )
        allow(@meraki).to receive(:get_network).and_return( response )
        
        rep = @meraki.get_network(network_id: :good_id)

        expect(rep.code).to eq 200
      end

      it 'retrieves a valid json object of a network' do
        response = double
        
        allow(response).to receive(:body).and_return( @network )
        allow(@meraki).to receive(:get_network).and_return( response )        
        rep = @meraki.get_network(network_id: :good_id)

        expect(@meraki.valid_json?(rep.body)).to eq true
        expect(rep.body).to eq @network
      end
    end

    context 'when network id is invalid' do
      it 'responds with 404 code' do
        response = double

        allow(response).to receive(:code) { 404 }
        allow(@meraki).to receive(:get_network).and_return( response )
        
        rep = @meraki.get_network(network_id: :bad_id)

        expect(rep.code).to eq 404
      end
    end

    context 'when called without providing network id' do
      it 'responds with ArgumentError' do
        expect { @meraki.get_network() }.to raise_exception(ArgumentError)
        expect { @meraki.get_network(network_id: :id) }.to_not raise_exception
      end
    end
  end
    
  describe '#getNetworks' do
    context 'when network id is valid' do      
      it 'responds with 200 ' do
        response = double

        allow(response).to receive(:code).and_return( 200 )
        allow(@meraki).to receive(:get_networks).and_return( response )
        
        rep = @meraki.get_networks()

        expect(rep.code).to eq 200
      end

      it 'retrieves a valid json object with array of networks' do
        response = double
        
        allow(response).to receive(:body).and_return( @networks )
        allow(@meraki).to receive(:get_networks).and_return( response )        
        rep = @meraki.get_networks()

        expect(@meraki.valid_json?(rep.body)).to eq true
        expect(rep.body).to eq @networks
      end
    end
  end
  
  describe '#updateNetwork' do
    context 'when network id and json valid' do      
      it 'responds with 200 ' do
        response = double

        allow(response).to receive(:code).and_return( 200 )
        allow(@meraki).to receive(:update_network).and_return( response )
        
        rep = @meraki.update_network(network_id: :good_id,
                                     json: :good_json)

        expect(rep.code).to eq 200
      end

      it 'returns a valid json object of updated network' do
        response = double

        json = JSON.parse(@network)
        expect(json.has_key? "name").to eq true
        expect(json.has_key? "timeZone").to eq true
        expect(json.has_key? "tags").to eq true
        
        allow(response).to receive(:body).and_return( @network )
        allow(@meraki).to receive(:update_network).and_return( response )        
        rep = @meraki.update_network(network_id: :good_id,
                                     json: :good_json)

        expect(@meraki.valid_json?(rep.body)).to eq true
        expect(rep.body).to eq @network
      end
    end

    context 'when network id is invalid' do
      it 'responds with 404 code' do
        response = double

        allow(response).to receive(:code) { 404 }
        allow(@meraki).to receive(:update_network).and_return( response )
        
        rep = @meraki.update_network(network_id: :bad_id,
                                    json: @network)

        expect(rep.code).to eq 404
      end
    end

    context 'when called without network id and valid json' do
      it 'responds with ArgumentError' do
        expect { @meraki.update_network() }.to raise_exception(ArgumentError)
        expect { @meraki.update_network(network_id: :id) }.to raise_exception(ArgumentError)
        allow(@meraki).to receive(:update_network).and_return( @network )
        expect { @meraki.update_network(network_id: :id,
                                        json: @network) }.to_not raise_exception
      end
    end
  end

  describe '#createNetwork' do
    context 'when network id and json are valid' do
      it 'responds with 201' do
        response = double

        json = JSON.parse(@network)
        expect(json.has_key? "name").to eq true
        expect(json.has_key? "timeZone").to eq true
        expect(json.has_key? "tags").to eq true
        expect(json.has_key? "type").to eq true        
        
        allow(response).to receive(:code).and_return( 201 )
        allow(@meraki).to receive(:create_network).and_return( response )
        
        rep = @meraki.create_network(network_id: :good_id)

        expect(rep.code).to eq 201
      end
    end

    context 'when passed invalid json' do
      it 'responds with an ArgumentError' do
        bad_json = "Not a real json object"
        
        expect { @meraki.create_network(network_id: :id,
                                        json: bad_json) }.to raise_exception(ArgumentError)
      end
    end
      
    context 'when network id is invalid' do
      it 'responds with 404 code' do
        response = double

        allow(response).to receive(:code) { 404 }
        allow(@meraki).to receive(:create_network).and_return( response )
        
        rep = @meraki.create_network(network_id: :bad_id,
                                     json: @network)

        expect(rep.code).to eq 404
      end
    end

    context 'when called without network id' do
      it 'responds with ArgumentError' do
        expect { @meraki.create_network() }.to raise_exception(ArgumentError)
        expect { @meraki.create_network(network_id: :id) }.to raise_exception(ArgumentError)
        expect { @meraki.create_network(network_id: :id,
                                        json: @network) }.to_not raise_exception
      end
    end
  end

  describe '#deleteNetwork' do
    context 'when network id is valid' do      
      it 'responds with 204 ' do
        response = double

        allow(response).to receive(:code).and_return( 204 )
        allow(@meraki).to receive(:delete_network).and_return( response )
        
        rep = @meraki.delete_network(network_id: :good_id)

        expect(rep.code).to eq 204
      end
    end

    context 'when network id is invalid' do
      it 'responds with 404 code' do
        response = double

        allow(response).to receive(:code) { 404 }
        allow(@meraki).to receive(:delete_network).and_return( response )
        
        rep = @meraki.delete_network(network_id: :bad_id)

        expect(rep.code).to eq 404
      end
    end

    context 'when called without network id' do
      it 'responds with ArgumentError' do
        expect { @meraki.delete_network() }.to raise_exception(ArgumentError)
        expect { @meraki.delete_network(network_id: :id) }.to_not raise_exception
      end
    end
  end

  describe '#bindNetToTemplate' do
    context 'when called with valid network_id and json' do
      it 'responds with 200 ' do
        response = double

        allow(response).to receive(:code).and_return( 200 )
        allow(@meraki).to receive(:bind_net_to_template).and_return( response )
        
        rep = @meraki.bind_net_to_template(network_id: :good_id,
                                           json: :good_json)

        expect(rep.code).to eq 200
      end
    end
    
    context 'when network id is invalid' do
      it 'responds with 404 code' do
        response = double

        allow(response).to receive(:code) { 404 }
        allow(@meraki).to receive(:bind_net_to_template).and_return( response )
        
        rep = @meraki.bind_net_to_template(network_id: :bad_id,
                                           json: :good_json)

        expect(rep.code).to eq 404
      end
    end

    context 'when json lacks configTemplateId' do
      it 'responds with ArgumentError' do
        bad_json = "This is bad json"

        expect { @meraki.bind_net_to_template(network_id: :good_id,
                                              json: bad_json) }.to raise_exception(ArgumentError)
      end
    end
    
    context 'when called without network id or json' do
      it 'responds with ArgumentError' do
        expect { @meraki.bind_net_to_template() }.to raise_exception(ArgumentError)
        expect { @meraki.bind_net_to_template(network_id: :id) }.to raise_exception(ArgumentError)
      end
    end

    context 'when called with proper parameters' do
      it 'does NOT raise an ArgumentError' do
        good_json = '{"configTemplateId":"N_1234", "autoBind":false}'

        response = double

        allow(response).to receive(:code) { 200 }
        
        allow(@meraki).to receive(:bind_net_to_template).and_return( response )
        expect { @meraki.bind_net_to_template(network_id: :id,
                                              json: good_json) }.to_not raise_exception

        rep = @meraki.bind_net_to_template(network_id: :id,
                                           json: good_json)
        expect(rep.code).to eq 200
      end
    end
  end

  describe '#unbindNetFromTemplate' do
    context 'when called with valid network_id' do
      it 'responds with 200 ' do
        response = double

        allow(response).to receive(:code).and_return( 200 )
        allow(@meraki).to receive(:unbind_net_from_template).and_return( response )
        
        rep = @meraki.unbind_net_from_template(network_id: :good_id)

        expect(rep.code).to eq 200
      end
    end
    
    context 'when network id is invalid' do
      it 'responds with 404 code' do
        response = double

        allow(response).to receive(:code) { 404 }
        allow(@meraki).to receive(:unbind_net_from_template).and_return( response )
        
        rep = @meraki.unbind_net_from_template(network_id: :bad_id)

        expect(rep.code).to eq 404
      end
    end
    
    context 'when called without network id' do
      it 'responds with ArgumentError' do
        expect { @meraki.unbind_net_from_template() }.to raise_exception(ArgumentError)
      end
    end
  end

  describe '#getSite2SiteVPN' do
    context 'when called with valid network id' do
      it 'responds with 200 ' do
        response = double

        allow(response).to receive(:code).and_return( 200 )
        allow(@meraki).to receive(:get_site2site_vpn).and_return( response )
        
        rep = @meraki.get_site2site_vpn(network_id: :good_id)

        expect(rep.code).to eq 200
      end

      it 'returns a valid json object of site-site VPN settings' do
        response = double

        json = JSON.parse(@s2sVPN)
        expect(json.has_key? "mode").to eq true
        expect(json.has_key? "hubs").to eq true
        expect(json.has_key? "subnets").to eq true
        
        allow(response).to receive(:body).and_return( @s2sVPN )
        allow(@meraki).to receive(:get_site2site_vpn).and_return( response )        
        rep = @meraki.get_site2site_vpn(network_id: :good_id)

        expect(@meraki.valid_json?(rep.body)).to eq true
        expect(rep.body).to eq @s2sVPN
      end  
    end
    
    context 'when network id is invalid' do
      it 'responds with 404 code' do
        response = double

        allow(response).to receive(:code) { 404 }
        allow(@meraki).to receive(:get_site2site_vpn).and_return( response )
        
        rep = @meraki.get_site2site_vpn(network_id: :bad_id)

        expect(rep.code).to eq 404
      end
    end
    
    context 'when called without network id' do
      it 'responds with ArgumentError' do
        expect { @meraki.get_site2site_vpn() }.to raise_exception(ArgumentError)
      end
    end
  end

  describe '#updateSite2SiteVPN' do
    context 'when called with valid network id' do
      it 'responds with 200 ' do
        response = double

        allow(response).to receive(:code).and_return( 200 )
        allow(@meraki).to receive(:update_site2site_vpn).and_return( response )
        
        rep = @meraki.update_site2site_vpn(network_id: :good_id)

        expect(rep.code).to eq 200
      end

      it 'returns a valid json object of site-site VPN settings' do
        response = double

        json = JSON.parse(@s2sVPN)
        expect(json.has_key? "mode").to eq true
        expect(json.has_key? "hubs").to eq true
        expect(json.has_key? "subnets").to eq true
        
        allow(response).to receive(:body).and_return( @s2sVPN )
        allow(@meraki).to receive(:update_site2site_vpn).and_return( response )        
        rep = @meraki.update_site2site_vpn(network_id: :good_id,
                                           json: @s2sVPN)

        expect(@meraki.valid_json?(rep.body)).to eq true
        expect(rep.body).to eq @s2sVPN
      end  
    end
    
    context 'when network id is invalid' do
      it 'responds with 404 code' do
        response = double

        allow(response).to receive(:code) { 404 }
        allow(@meraki).to receive(:update_site2site_vpn).and_return( response )
        
        rep = @meraki.update_site2site_vpn(network_id: :bad_id,
                                           json: :good_json)

        expect(rep.code).to eq 404
      end
    end
    
    context 'when called without network id' do
      it 'responds with ArgumentError' do
        expect { @meraki.update_site2site_vpn(json: :good_json) }.to raise_exception(ArgumentError)
      end
    end

    context 'when called without json' do
      it 'responds with ArgumentError' do
        expect { @meraki.update_site2site_vpn(network_id: :good_id) }.
          to raise_exception(ArgumentError)
      end
    end

   p context 'when json lacks required attribute' do
      it 'responds with ArgumentError' do
        json = JSON.parse(@s2sVPN)
        json.delete("subnets")
        json = json.to_json
        
        expect(@meraki.valid_json?(json)).to eq true
        expect { @meraki.update_site2site_vpn(network_id: :good_id,
                                              json: json) }.
          to raise_exception(ArgumentError)
      end
    end
  end
end
=end
