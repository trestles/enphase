
require "enphase/version"
require "enphase/config"
require "enphase/api_params"
require "enphase/api_wrapper"

require "faraday"
require "json"
require "enphase/fixnum"
require "active_support/core_ext/time/calculations"

# The main entry of the module. Provides several methods that calls EnPhase API.
#
# For example:
#   # The following will call get_enphase_summary EnPhase API and returns the enphase summary.
#   require "enphase"
#   Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
#   response = Enphase.get_enphase_summary("4d7a45774e6a41320a", 67)
#   # => [enphase_summary]
#
# Author: TCSASSEMBLER
# Version: 1.0

module Enphase

  # Public: Sets enphase_key for the API calls.
  #
  # enphase_key - enphase_key to be passed in the API.
  #
  # Examples
  #   require "enphase"
  #   Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")

  def self.set_enphase_key(enphase_key)
    @enphase_key = enphase_key

  end

  def self.get_enphase_index(user_id)
    #endpoint = build_endpoint("summary")
    #{}"/systems"
    #query_string = build_query_string(user_id, :get_enphase_summary, {})
    query_string = build_query_string(user_id, :get_enphase_energy_lifetime)
    #Enphase::ApiWrapper.get_response(endpoint, query_string)
    Enphase::ApiWrapper.get_response("/systems", query_string)
  end


  # Public:  Calls /systems/system_id/summary EnPhase API.
  #
  # user_id - ENphase user ID obtained from the Enlighten API.
  # system_id - ID of the system to be passed in the API.
  #
  # Examples
  #   require "enphase"
  #   Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
  #   response = Enphase.get_enphase_summary("4d7a45774e6a41320a", 67)
  #   # => [enphase_summary]
  #
  # Returns JSON response of the API with status, and body

  def self.get_enphase_summary(user_id, system_id)
    endpoint = build_endpoint("summary", system_id)
    query_string = build_query_string(user_id, :get_enphase_summary, {})
    Enphase::ApiWrapper.get_response(endpoint, query_string)
  end


  # Public:  Calls /systems/system_id/summary EnPhase API.
  #
  # user_id - ENphase user ID obtained from the Enlighten API.
  # system_id - ID of the system to be passed in the API.
  # params - summary_date for which the data to be retreived.
  #
  # Examples
  #   require "enphase"
  #   Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
  #   response = Enphase.get_enphase_feed("4d7a45774e6a41320a", 67, :summary_date => "2015-01-02")
  #   # => [enphase_summary]
  #
  # Returns JSON response of the API with status, and body

  def self.get_enphase_feed(user_id, system_id, params)
    endpoint = build_endpoint("summary", system_id)
    query_string = build_query_string(user_id, :get_enphase_feed, params)

    Enphase::ApiWrapper.get_response(endpoint, query_string)
  end


  # Public:  Calls /systems/system_id/summary EnPhase API.
  # Accepts enphase_user_id and system_id as input params.
  #
  # user_id - ENphase user ID obtained from the Enlighten API.
  # system_id - ID of the system to be passed in the API.
  #
  # Examples
  #   require "enphase"
  #   Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
  #   response = Enphase.get_enphase_last_7_day_summaries("4d7a45774e6a41320a", 67)
  #
  # Returns total energy value of summaries with API response status

  def self.get_enphase_last_7_day_summaries(user_id, system_id)
    total_value = 0
    (1..7).each do |i|
      @response = get_enphase_feed(user_id, system_id, { :summary_date => i.days.ago.strftime("%Y-%m-%d") })
      if @response.status == 200
        body_json = JSON.parse(@response.body)
        total_value += body_json['energy_today']
      else
        return @response
      end
    end

    # Check with client on what all additional data to be sent.
    { :status => @response.status, :body => { :total_energy_value => total_value }}
  end


  # Public:  Calls /systems/system_id/stats EnPhase API.
  #
  # user_id - ENphase user ID obtained from the Enlighten API.
  # system_id - ID of the system to be passed in the API.
  #
  # Examples
  #   require "enphase"
  #   Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
  #   response = Enphase.get_enphase_last_7_day_stats("4d7a45774e6a41320a", 67)
  #   # => [enphase_stat]
  #
  # Returns JSON response of the API with status, and body

  def self.get_enphase_last_7_day_stats(user_id, system_id)
    params = { :start_at => 7.days.ago.beginning_of_day.to_i.to_s,
      :end_at => (1.days.ago.end_of_day.to_i).to_s }
    get_enphase_stats(user_id, system_id, params)
  end


  # Public:  Calls /systems/system_id/stats EnPhase API.
  #
  # user_id - ENphase user ID obtained from the Enlighten API.
  # system_id - ID of the system to be passed in the API.
  #
  # Examples
  #   require "enphase"
  #   Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
  #   response = Enphase.get_enphase_today_stats("4d7a45774e6a41320a", 67)
  #   # => [enphase_stat]
  #
  # Returns JSON response of the API with status, and body.

  def self.get_enphase_today_stats(user_id, system_id)
    params = { :start_at => Time.now.beginning_of_day.to_i.to_s,
      :end_at => Time.now.to_i.to_s }
    get_enphase_stats(user_id, system_id, params)
  end


  # Public:  Calls /systems/system_id/stats EnPhase API.
  #
  # user_id - ENphase user ID obtained from the Enlighten API.
  # system_id - ID of the system to be passed in the API.
  # params - start_at and end_at params for which historic stats need to be retrieved.
  #
  # Examples
  #   require "enphase"
  #   Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
  #   response = Enphase.get_enphase_historical_stats("4d7a45774e6a41320a", 67,
  #                        :start_at => "1411822918" , :end_at => "1414414914" )
  #   # => [enphase_stat]
  #
  # Returns JSON response of the API with status, and body.

  def self.get_enphase_historical_stats(user_id, system_id, params)
    get_enphase_stats(user_id, system_id, params)
  end


  # Calls /systems/system_id/energy_lifetime EnPhase API.
  #
  # user_id - ENphase user ID obtained from the Enlighten API.
  # system_id - ID of the system to be passed in the API.
  #
  # Examples
  #   require "enphase"
  #   Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
  #   response = Enphase.get_enphase_energy_lifetime("4d7a45774e6a41320a", 67)
  #   # => [enphase_energy_lifetime_daily_readings]
  #
  # Returns JSON response of the API with status, and body

  def self.get_enphase_energy_lifetime(user_id, system_id)
    endpoint = build_endpoint("energy_lifetime", system_id)
    query_string = build_query_string(user_id, :get_enphase_energy_lifetime)

    Enphase::ApiWrapper.get_response(endpoint, query_string)
  end

  private
    # Builds the API endpoint with the given system_id param
    def self.build_endpoint(api, system_id)
      Enphase::ApiParams.validate_system_id(system_id)
      %(/systems/#{system_id}/#{api})
    end

    # Builds query string with the input params, API key and enphase_user_id values.
    def self.build_query_string(user_id, api_method, params = {})
      query_string = Enphase::ApiParams.construct_query_string(api_method, params)
      %(#{query_string}key=#{@enphase_key}&user_id=#{user_id})
    end

    # This methods wraps /systems/system_id/stats EnPhase API and is used for retrieving today's stats,
    # last 7 days' stats and historical stats.
    #
    # Bug in EnPhase systems - Subracting 12 seconds from the endtime.
    def self.get_enphase_stats(user_id, system_id, params)
      endpoint = build_endpoint("stats", system_id)
      params[:end_at] = (params[:end_at].to_i - 12).to_s
      query_string = build_query_string(user_id, :get_enphase_stats, params)

      Enphase::ApiWrapper.get_response(endpoint, query_string)
    end

end
