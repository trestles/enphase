# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This module fires the API call to EnPhase systems.
# Uses Faraday for the API communications.
# 
# Author: TCSASSEMBLER
# Version: 1.0

module Enphase
  module ApiWrapper
    
    # This method makes the call to the APIs.
    # Accepts the API endpoint and the query string params as input.
    # Returns the response returned by the EnPhase APIs.
    def self.get_response(endpoint, query_string)
      url = construct_url(endpoint, query_string)
      connection.get url
    end

    private
      # This methods builds the connection object in Farday.
      # The connection is initialized with the EnPhase API URL.
      def self.connection    
        Faraday.new(:url => Enphase::Config::URL) do |c|
          c.use Faraday::Request::UrlEncoded  # encode request params as "www-form-urlencoded"
          c.use Faraday::Response::Logger     # log request & response to STDOUT
          c.use Faraday::Adapter::NetHttp     # perform requests with Net::HTTP
        end
      end

      # This method constructs the API request URL with the endpoint and querystring.
      def self.construct_url(endpoint, query_string)
        %(#{Enphase::Config::URL}/api/#{Enphase::Config::VERSION}#{endpoint}?#{query_string})
      end

  end
end