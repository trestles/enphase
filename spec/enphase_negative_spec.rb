# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This module has several examples to test negative use cases of EnPhase API.
# 
# Author: TCSASSEMBLER
# Version: 1.0

require 'spec_helper'

describe Enphase do

  SAMPLE_USER_ID = "4d7a45774e6a41320a"
  SAMPLE_SYSTEM_ID = "67"

  INVALID_USER_ID = "nwde3foifc"
  INVALID_SYSTEM_ID = "-100"

  before(:each) do
    sleep(20)
  end

  it 'has a version number' do
    expect(Enphase::VERSION).not_to be nil
  end

  # This checks for invalid system_id param in the API.
  it 'expect argument_error when system_id is invalid' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    expect { Enphase.get_enphase_summary(SAMPLE_USER_ID, INVALID_SYSTEM_ID) 
      }.to raise_error(ArgumentError, /invalid system_id param/)
  end

  # This checks for invalid summary_date param in the API.
  it 'expect argument_error when summary_date is invalid' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    expect { Enphase.get_enphase_feed(SAMPLE_USER_ID, SAMPLE_SYSTEM_ID, { :summary_date => "aa-tt-vv" }) 
      }.to raise_error(ArgumentError, /invalid date/)
  end

  # This checks for mandatory params in the API
  it 'expect argument_error when summary_date is missing' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    expect { Enphase.get_enphase_feed(SAMPLE_USER_ID, SAMPLE_SYSTEM_ID, {}) 
      }.to raise_error(ArgumentError, /missing params/)
  end

  # This checks end_at is greater than start_at case in get_enphase_historical_stats
  it 'Expect argument_error when time is invalid in get_enphase_historical_stats API' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    
    expect { 
      Enphase.get_enphase_historical_stats(SAMPLE_USER_ID, 
        SAMPLE_SYSTEM_ID, { :start_at => "-1" , :end_at => "-2" })
    }.to raise_error(ArgumentError, /invalid date/)
  end

  # This checks for mandatory params in the API
  it 'Expect argument_error when mandatory params are missing in get_enphase_historical_stats API' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    
    expect { 
      Enphase.get_enphase_historical_stats(SAMPLE_USER_ID, SAMPLE_SYSTEM_ID, {})
    }.to raise_error(ArgumentError, /missing params/)
  end

  # This checks end_at is greater than start_at case in get_enphase_historical_stats
  it 'Expect range error when end_at < start_at in get_enphase_historical_stats API' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    
    expect { 
      Enphase.get_enphase_historical_stats(SAMPLE_USER_ID, 
        SAMPLE_SYSTEM_ID, { :start_at => "1427824234" , :end_at => "1427737818" })
    }.to raise_error(ArgumentError, /invalid date range/)
  end

  it 'checks for invalid user_id in get_enphase_summary API' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    response = Enphase.get_enphase_summary(INVALID_USER_ID, SAMPLE_SYSTEM_ID)
    
    response.status.should eql 401
    response.body.should =~ /Not authorized to access requested resource/
  end

  it 'checks missing site in get_enphase_feed API' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    response = Enphase.get_enphase_feed(SAMPLE_USER_ID, "1", {:summary_date => "2015-01-02"})
    
    response.status.should eql 404
    response.body.should =~ /Couldn't find Site/
  end

  it 'calls get_enphase_last_7_day_summaries API with invalid user_id' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    response = Enphase.get_enphase_last_7_day_summaries(INVALID_USER_ID, SAMPLE_SYSTEM_ID)
    response.status.should eql 401
    response.body.should =~ /Not authorized/
  end

  it 'calls get_enphase_last_7_day_stats API with non existent systems' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    response = Enphase.get_enphase_last_7_day_stats(SAMPLE_USER_ID, "1")
    response.status.should eql 404
    response.body.should =~ /Couldn't find Site/
  end
  
end
