# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This module has several examples to test all use cases of the EnPhase API.
# 
# Author: TCSASSEMBLER
# Version: 1.0

require 'spec_helper'

describe Enphase do

  SAMPLE_USER_ID = "4d7a45774e6a41320a"
  SAMPLE_SYSTEM_ID = 67

  before(:each) do
    sleep(25)
  end

  it 'has a version number' do
    expect(Enphase::VERSION).not_to be nil
  end

  it 'calls get_enphase_summary API with right params' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    response = Enphase.get_enphase_summary(SAMPLE_USER_ID, SAMPLE_SYSTEM_ID)
    response.status.should eql 200
    response.body.should =~ /size_w/
  end

  it 'calls get_enphase_feed API with right params' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    response = Enphase.get_enphase_feed(SAMPLE_USER_ID, 
            SAMPLE_SYSTEM_ID, {:summary_date => "2015-01-02"})
    response.status.should eql 200
    response.body.should =~ /energy_lifetime/
  end

  it 'calls get_enphase_last_7_day_summaries API with right params' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    response = Enphase.get_enphase_last_7_day_summaries(SAMPLE_USER_ID, SAMPLE_SYSTEM_ID)
    response.should_not be_nil
  end

  it 'calls get_enphase_last_7_day_stats API with right params' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    response = Enphase.get_enphase_last_7_day_stats(SAMPLE_USER_ID, SAMPLE_SYSTEM_ID)
    response.status.should eql 200
    response.body.should =~ /devices_reporting/
  end

  it 'calls get_enphase_today_stats API with right params' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    response = Enphase.get_enphase_today_stats(SAMPLE_USER_ID, SAMPLE_SYSTEM_ID)
    response.status.should eql 200
    response.body.should =~ /total_devices/
  end

  it 'calls get_enphase_historical_stats API with right params' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    response = Enphase.get_enphase_historical_stats(SAMPLE_USER_ID, 
      SAMPLE_SYSTEM_ID, { :start_at => "1411822918" , :end_at => "1414414914" })
    response.status.should eql 200
    response.body.should =~ /enwh/
  end

  it 'calls get_enphase_energy_lifetime API with right params' do
    Enphase.set_enphase_key("faff6d1c8fdd381dcbb9ca0bf90db5d7")
    response = Enphase.get_enphase_energy_lifetime(SAMPLE_USER_ID, SAMPLE_SYSTEM_ID)
    response.status.should eql 200
    response.body.should =~ /production/
  end
  
end
