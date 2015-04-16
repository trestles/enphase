# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This class includes helper methods for days. helper functions that are Used 
# for getting time elapsed data.(Eg. 1.days.ago etc)
# 
# Author: TCSASSEMBLER
# Version: 1.0

class Fixnum
  # defines seconds in a day
  SECONDS_IN_DAY = 24 * 60 * 60

  # Calculates number of seconds in the given day
  def days
    self * SECONDS_IN_DAY
  end

  # Calculates time in seconds elapsed.
  def ago
    Time.now - self
  end
end