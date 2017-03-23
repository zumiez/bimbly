require 'rest_client'
require 'yaml'
require 'json'
require 'pathname'
require 'pp'

class Bimbly
  attr_reader :data_type, :error_codes, :error_names, :obj_sets
  attr_accessor :array, :base_url, :cert, :doc_pointer, :file, :file_select, :headers, :meth_name,
                :menu, :param_pointer, :password, :pointer, :port, :req_pointer, :user, :verb

  def initialize(opts = {})
    # Read in setup files
    #@error_codes = YAML.load(File.read("#{File.dirname(__FILE__)}/errors_by_code.yml"))
    #@error_names = YAML.load(File.read("#{File.dirname(__FILE__)}/errors_by_name.yml"))
    @error_codes = YAML.load(File.read("#{File.dirname(__FILE__)}/error_codes.yml"))
    #@obj_sets = YAML.load(File.read("#{File.dirname(__FILE__)}/object_sets.yml"))
    @obj_sets = YAML.load(File.read("#{File.dirname(__FILE__)}/object_sets_v2.yml"))
    @data_type = YAML.load(File.read("#{File.dirname(__FILE__)}/data_types.yml"))

    @meth_name = nil
    
    @base_url = "NotConnected"
    @menu = []
    @param_pointer = @obj_sets
    @doc_pointer = @obj_sets
    @req_pointer = @obj_sets
    
    gen_methods
    new_connection(opts)
  end

  def call(opts = {})
    verb = @verb
    payload = @payload
    uri = @uri
    reset
    
    raise StandardError, "Instantiate a connection to an array" if @array.nil?

    raise StandardError, "Method to be used has not been loaded" if verb.nil?
    
    # Check if url is valid
    raise ArgumentError, "Invalid URL: #{uri}" unless uri =~ /\A#{URI::regexp}\z/

    # Do some payload stuff to wrap with 'data' and make sure it's usable
    
    payload = payload.to_json if payload.class == Hash
    
    begin
      response =  RestClient::Request.execute(
        method: verb.to_sym,
        url: uri,
        ssl_ca_file: @cert,
        headers: @headers,
        payload: payload
      )
    rescue RestClient::ExceptionWithResponse => e
      puts "Response Code: #{e.response.code}"
      puts "Response Headers:"
      pp e.response.headers
      puts "Response Body:"
      pp error_format(e.response.body)
      puts "Response Object:"
      puts e.response.request.inspect
    end
    
    begin
      JSON.parse(response.body) unless response.nil? || response.body == ''
    rescue JSON::ParserError => e
      puts e
    end
  end

  def error_format(messages)
    message_array = []
    JSON.parse(messages)["messages"].each { |message|
      message.merge!(@error_names[message["code"]])
      message.delete("Error_Desc")
      message_array << message
    }
    message_array
  end

  def new_connection(opts = {})
    @file = opts[:file]
    @file_select = opts[:file_select]
    @array = opts[:array]
    @cert = opts[:cert]
    @port = opts[:port]
    @user = opts[:user]
    @password = opts[:password]
    
    return if opts.empty?
    
    if @file
      conn_data = YAML.load(File.read(File.expand_path(@file)))
      puts File.expand_path(@file)
      puts conn_data
      conn_data = conn_data[@file_select] if @file_select
      @array = conn_data["array"]
      @cert = conn_data["cert"]
      @user = conn_data["user"]
      @password = conn_data["password"]
    end

    @port = "5392" if @port.nil?
                        
    raise ArgumentError, "You must provide an array" if @array.nil?
    raise ArgumentError, "You must provide a CA cert" if @cert.nil?
    raise ArgumentError, "You must provide a user" if @user.nil?
    raise ArgumentError, "You must provide a password" if @password.nil?    

    @base_url = "https://#{array}:#{port}"
    @uri = "#{@base_url}/v1/tokens"

    # Get initial connection credentials
    creds = { data: {
                         username: @user,
                         password: @password
                       }
             }
 
    begin    
      response = RestClient::Request.execute(
        method: :post,
        url: @uri,
        payload: creds.to_json,
        ssl_ca_file: @cert,
        ssl_ciphers: 'AESGCM:!aNULL'      
      )
    rescue RestClient::ExceptionWithResponse => e
      puts "Response Code: #{e.response.code}"
      puts "Response Headers: #{e.response.headers}"
      puts "Response Body: #{e.response.body}"
      puts "Response Object: #{e.response.request.inspect}"
    end

    token = JSON.parse(response)["data"]["session_token"]
    @headers = { 'X-Auth-Token' => token }
  end

  def reset
    @verb = nil
    @payload = nil
    @uri = nil
    @meth_name = nil
    @doc_pointer = @obj_sets
    @param_pointer = @obj_sets
  end
  
  def details
    puts "Method Selected: #{@meth_name}"
    puts "URI: #{@uri}"
    puts "Verb: #{@verb}"
    if not @payload.nil?
      puts "Payload:"
      pp @payload
    else
      puts "Payload: n/a"
    end
    return
  end

  def doc
    puts @doc_pointer.to_yaml
  end

  def parameters
    @param_pointer
  end

  def request
    puts @req_pointer.to_yaml
  end
  
  def available_methods
    self.methods - Object.methods
  end
  
  def data_types(type = nil)
    if type
      return @data_type[type]
    elsif @param_pointer.nil?
      return @data_type
    else
      @param_pointer.each { |key,value|
        puts "[#{key}]" 
        @data_type[value].each { |key, value|
          puts "#{key}: #{value}"
        }
        puts ""
      }
    end
    
    return nil
  end

  def build_params(hash)
    raise ArgumentError, "Please provide a valid hash for parameters" unless
      hash.instance_of? Hash and hash != {}
    url_params = "?"
    size_count = 0
    hash.each { |key, value|
      url_params = "#{url_params}#{key}=#{value}"
      size_count += 1
      url_params = "#{url_params}&" unless size_count == hash.size
    }
    url_params
  end

  def gen_uri(opts = {})
    url_params = build_params(opts[:params]) if opts[:params]
    uri = "#{@base_url}/#{opts[:url_suffix]}#{url_params}"
  end
  
  def gen_method_hash
    method_hash = {}
    name = ""
    @obj_sets.each { |obj_key, obj_value|
      obj_value.each { |op_key, op_value|
        method_suffix = ""
        op_value.each { |key, value|
          next if not key.match(/DELETE|GET|POST|PUT/)
          if key.match(/id/)
            method_suffix = "_by_id"
          elsif key.match(/detail/)
            method_suffix = "_detailed"
          end
          verb, url_suffix = key.split(' ')
          hash = {}
          hash[:verb] = verb.downcase.to_sym
          hash[:url_suffix] = url_suffix
          hash[:avail_params] = value
          hash[:request] = @obj_sets[obj_key][op_key]["Request"]
          hash[:object] = obj_key
          hash[:op] = op_key

          name = "#{op_key}_#{obj_key}#{method_suffix}"
          method_hash[name.to_sym] = hash
          @menu.push name
        }
      }
    }
    method_hash
  end

  def gen_methods
    method_hash = gen_method_hash
    method_hash.each { |method_name, hash|
      define_singleton_method(method_name) { |opts = {}|
        @param_pointer = hash[:avail_params]
        @doc_pointer = @obj_sets[hash[:object]][hash[:op]]
        @req_pointer = @obj_sets[hash[:object]][hash[:op]]["Request"]        
        @meth_name = method_name
        
        raise ArgumentError, "Please provide id" if method_name.match(/id/) and opts[:id].nil?
        url_suffix = hash[:url_suffix]
        url_suffix = url_suffix.gsub(/\/id/, "/#{opts[:id]}") if method_name.match(/id/)

        uri = gen_uri(url_suffix: url_suffix,
                      params: opts[:params])

        @uri = uri
        @verb = hash[:verb]
        @payload = opts[:payload]        
        
        if not opts[:params].nil?
          opts[:params].each { |key, value|
            raise ArgumentError,
                  "Invalid parameter for #{method_name}: #{key}" unless hash[:avail_params].include?(key) 
          }
        end

        # Maybe pull this out into its own method
        # Check for mandatory payload info
        mando_array = []
        if not hash[:request].nil?
          hash[:request].each { |key, value|
            mando_array << key
          }
        end

        raise ArgumentError,
              "Must supply :payload with attributes #{mando_array} on #{method_name}" if
          not mando_array.empty? and opts[:payload].nil?
        
        mando_array.each { |ele|
          raise ArgumentError,
                "\'#{ele}\' is a mandatory attribute in the payload for #{method_name}: Please supply these attributes #{mando_array}" unless
            opts[:payload].keys.to_s.include?(ele)
        }

        if not opts[:payload].nil?
          opts[:payload].keys.each { |key|
            raise ArgumentError,
                  "The attribute \'#{key}\' is not an available attribute for #{method_name}" unless
              hash[:request].keys.include?(key.to_s)
          }
        end
        
        self
      }
    }
  end
end
