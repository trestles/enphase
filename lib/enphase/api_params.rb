# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This module performs basic validations on input params of EnPhase API.
# Also, this method constructs the query string to be used in the requests.
# 
# Author: TCSASSEMBLER
# Version: 1.0

module Enphase
  module ApiParams

    # This constant defines the required params of the respective API methods.
    PARAM_MAPPINGS = {
      :get_enphase_summary => [],
      :get_enphase_feed => [:summary_date],
      :get_enphase_stats => [:start_at, :end_at],
      :get_enphase_energy_lifetime => [],
      :get_enphase_historical_stats => [:start_at, :end_at]
    }

    # Checks if the given system_id is a number (system_id.to_i should not be 0) and not negative
    # Raises ArgumentError if the conditions are not met.
    def self.validate_system_id(system_id)
      if system_id.to_i <= 0
        raise ArgumentError, %(invalid system_id param) 
      end
    end
    
    # Builds the query string with the API method and the given params.
    # Raises ArgumentError if required params are missing.
    # Returns theconstructed query string.
    def self.construct_query_string(api_method, params)
      missing_params = check_for_missing_params(api_method, params)      
      unless missing_params.empty?
        raise ArgumentError, %(missing params - #{missing_params}) 
      end
      validate_date(params[:summary_date]) if api_method == :get_enphase_feed
      validate_time_range(params) if api_method == :get_enphase_stats

      PARAM_MAPPINGS[api_method].map {|attribute| %(#{attribute}=#{params[attribute]}&) }.join("")
    end

    # This method checks if the given summary date param in get_enphase_feed is valid.
    # Raises Invalid date error when invalid.
    def self.validate_date(date)
      Date.parse(date)
    end

    # This method checks of the start_at and end_at are numeric and form a valid date range.    
    # Checks for valid params in get_enphase_historical_stats.
    # Raises argument errors when conditions are not met.
    def self.validate_time_range(params)
      Time.at(params[:start_at].to_i)
      Time.at(params[:end_at].to_i)

      if params[:start_at].to_i > params[:end_at].to_i
        raise ArgumentError, %(invalid date range)
      end
    end

    private
      # This method uses PARAM_MAPPINGS constants and returns the missing mandatory params.
      # Accepts API method and the params as input.
      def self.check_for_missing_params(api_method, params)
        missing_params = []
        PARAM_MAPPINGS[api_method].each do |param|          
          missing_params << param unless params.keys.include?(param)
        end
        missing_params
      end
      
  end
end