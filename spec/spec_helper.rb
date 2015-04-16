# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This module represents the helper to spec files.
# 
# Author: TCSASSEMBLER
# Version: 1.0

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'enphase'
require 'simplecov'

SimpleCov.start do 
  add_group "lib", "lib"
end
