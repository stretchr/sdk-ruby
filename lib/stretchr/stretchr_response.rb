require 'json' unless defined? JSON

class Stretchr::Response

  attr_reader :json_string, :json_object, :status, :client_context, :data, :errors, :raw_response

  def initialize(options = nil)

    options ||= {}

    @raw_response = options[:response]

    if options[:json]
      
      # save the original json string
      @json_string = options[:json]
      @json_object = JSON.parse(@json_string)

      @status = @json_object["~s"]
      @client_context = @json_object["~x"]
      @data = @json_object["~d"]

      unless @json_object["~e"].nil?
        @errors = @json_object["~e"].collect {| error_obj | error_obj["~m"] }
      end

    end

  end

  # Gets whether this is a successful response.
  def success?
    @status >= 200 && @status <= 299
  end

end