require 'singleton'
require "time_scales/version"
require "time_scales/time_struct"
require "time_scales/units"
require "time_scales/parts"
require "time_scales/frame"

module TimeScales

  class TimeScalesError < StandardError ; end
  class NoPartOrUnitForKeyError < TimeScalesError ; end

end
