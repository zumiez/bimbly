require 'rest_client'
require 'yaml'
require 'json'
require 'pathname'
require 'pp'

class Bimbly
  attr_reader :data_type, :error_codes, :error_names, :obj_sets
  attr_accessor :array, :base_url, :cert, :doc_pointer, :file, :file_select, :headers, :mando_array,
                :meth_name, :menu, :param_pointer, :password, :pointer, :port, :req_pointer,
                :saved_array, :user, :verb

  MANDO_EXCEPT = { create_volumes: ['size'] }
  
  def initialize(opts = {})
    # Read in setup files
    if opts[:version] == "3"
      opts.delete(:version)
      @error_codes = YAML.load(File.read("#{File.dirname(__FILE__)}/error_codes_v3.yml"))
      @obj_sets = YAML.load(File.read("#{File.dirname(__FILE__)}/object_sets_v3.yml"))
      @data_type = YAML.load(File.read("#{File.dirname(__FILE__)}/data_types_v3.yml"))
    else
      @error_codes = YAML.load(File.read("#{File.dirname(__FILE__)}/error_codes_v4.yml"))
      @obj_sets = YAML.load(File.read("#{File.dirname(__FILE__)}/object_sets_v4.yml"))
      @data_type = YAML.load(File.read("#{File.dirname(__FILE__)}/data_types_v4.yml"))
    end
    
    @meth_name = nil
    @saved_array = []
    
    @base_url = "NotConnected"
    @menu = []
    @param_pointer = @obj_sets
    @doc_pointer = @obj_sets
    @req_pointer = @obj_sets
    
    gen_methods
    new_connection(opts)
  end

  def inspect
    "#<Bimbly:#{object_id}>"
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
    if not payload.nil?
#      payload = payload["data"] if payload.keys.size == 1 and payload.keys.include?("data")

      payload = { data: payload }
    end
    
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
      message.merge!(@error_codes[message["code"]])
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

    return nil
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

  def required
    @mando_array
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

  def save
    #Method to save call to array
    method_array = @meth_name.to_s.split("_")

    operation = method_array.shift

    if method_array.last == "id"
      method_array.pop(2)
    elsif method_array.last == "detailed"
      method_array.pop
    end
    
    object = method_array.join("_")
    
    operations_hash = {}
    
    if @meth_name.match(/_by_id/)
      id = @uri.match(/#{object}\/(.*)/)[1]
      id = id.split("/")[0]
      operations_hash['id'] = id unless id.nil?
    end
    
    operations_hash['params'] = extract_params if @uri.match(/\?/)
    operations_hash['request'] = @payload unless @payload.nil?

    if operations_hash.empty?
      @saved_array << { operation => [ object ] }
    else
      @saved_array << { operation => [ object => operations_hash ] }
    end
    
    reset
  end

  def review
    #Method to review calls that are saved
    @saved_array.each do |ele|
      pp ele
    end
    
    return nil
  end

  def create_playbook(file)
    #Method to output saved calls to a yaml formated playbook
    raise ArgumentError, "Supply #create_playbook with a file name" if file.nil?    
    File.write(file, @saved_array.to_yaml)

    return nil
  end

  def create_template(file)
    #Method to take saved calls, scrub data, and create a yml template for them    
    raise ArgumentError, "Supply #create_template with a file name" if file.nil?
  end

  def extract_params
    params_hash = {}
    params = @uri.split("?")[1]
    params_array = params.split("&")
    params_array.each do |param|
      key, value = param.split("=")

      params_hash[key] = value
    end
    params_hash
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

        payload = opts[:payload]
        # Unwrap the payload data if it is json or wrapped in 'data' so we can inspect the attrs
        if not payload.nil?
          payload = JSON.parse(payload) if payload.class == String
          payload = payload["data"] if payload.keys.include?("data")
          payload = Hash[payload.map{|(k,v)| [k.to_s,v]}]
        end
        
        @uri = uri
        @verb = hash[:verb]
        @payload = payload
        
        if not opts[:params].nil?
          opts[:params].each { |key, value|
            raise ArgumentError,
                  "Invalid parameter for #{method_name}: #{key}" unless hash[:avail_params].include?(key) 
          }
        end

        # Maybe pull this out into its own method
        # Check for mandatory payload info
        @mando_array = []
        if not hash[:request].nil?
          hash[:request].each { |key, value|
            @mando_array << key if value['mandatory'] == 'true'
            @mando_array << key if not MANDO_EXCEPT[method_name].nil? and
              MANDO_EXCEPT[method_name].include? key
          }
        end

        raise ArgumentError,
              "Must supply :payload with attributes #{@mando_array} on #{method_name}" if
          not @mando_array.empty? and payload.nil?
        
        @mando_array.each { |ele|
          raise ArgumentError,
                "\'#{ele}\' is a mandatory attribute in the payload for #{method_name}: Please supply these attributes #{@mando_array}" unless
            payload.keys.to_s.include?(ele)
        }

        if not payload.nil?
          payload.keys.each { |key|
            raise ArgumentError, "The method #{method_name} does not utilize :payload" if
              hash[:request].nil?
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
