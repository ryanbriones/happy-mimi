require "CGI"

module HappyMimi
  BASE_URI = "https://api.madmimi.com"
  
  def self.default_parameters=(new_default_parameters = {})
    @default_parameters ||= {}
    @default_parameters.merge!(new_default_parameters)
  end
  
  def self.default_parameters
    @default_parameters ||= {}
  end
  
  def self.clear_default_parameters!
    @default_parameters = {}
  end
  
  def self.call_api(url, *args)
    arg_params = args.last.is_a?(Hash) ? args.pop : {}
    request_params = default_parameters.merge(arg_params)
    http_method = args.shift || :get
    
    request_uri = URI.parse(BASE_URI)
    arg_uri = URI.parse(url)
    
    request_uri = request_uri.merge(arg_uri)
    request_uri.query = hash_to_http_pairs(request_params) if http_method == :get
            
    http = Net::HTTP.new(request_uri.host, request_uri.port)
    http.use_ssl = true if request_uri.scheme == "https"
    response = http.start do |http|
      path = (http_method == :get ? request_uri.request_uri : request_uri.path)
      data = (http_method == :post ? hash_to_http_pairs(request_params) : "")
      http.send(http_method, path, data)
    end
    
    response
  end
  
  def self.hash_to_http_pairs(hash)
    pairs = hash.inject([]) do |http_pairs, (key, value)|
      http_pairs << "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
    end
    
    pairs.join("&")
  end
end