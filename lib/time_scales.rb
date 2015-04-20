require 'singleton'
require "time_scales/version"
require "time_scales/time_struct"
require "time_scales/units"
require "time_scales/parts"
require "time_scales/frame"

module TimeScales
  class TimeScalesError < StandardError ; end
  class NoPartOrUnitForKeyError < TimeScalesError ; end

  def self.[](hash_or_first_part, *args)
    defines_type =
      Symbol === hash_or_first_part ||
      hash_or_first_part.respond_to?(:to_time_scales_part) ||
      hash_or_first_part.respond_to?(:to_time_scales_unit)
    if defines_type
      TimeScales::Frame.type_for( hash_or_first_part, *args )
    elsif hash_or_first_part.respond_to?( :to_hash ) || hash_or_first_part.respond_to?( :to_h )
      raise ArgumentError, "Must supply only a hash argument when first argument is a hash" unless args.empty?
      hash = hash_or_first_part.to_hash if hash_or_first_part.respond_to?( :to_hash )
      hash = hash_or_first_part.to_h if hash_or_first_part.respond_to?( :to_h )
      TimeScales::Frame[ hash_or_first_part ]
    else
      raise ArgumentError, "Must supply time-part key arguments or a single hash as arguments"
    end
  end
end
