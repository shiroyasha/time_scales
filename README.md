# TimeScales

Date/Time representations with specific scopes, units, and precisions.

## Installation

Add this line to your application's Gemfile:

```ruby gem 'time_scales' ```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install time_scales

## Usage

The fuctionality of TimeScales is primarily accessed through
frame types and instances of frame types.

It's probably most useful to start with some examples…

Example A:

    # Build a frame from part values, and get time value & range.

    frame = TimeScales[year: 2015, quarter: 4, month: 1, day: 21]
    
    puts frame.begin_time
    # Output: 2015-10-21 00:00:00 -0700
    
    puts frame.to_range
    # Output: 2015-10-21 00:00:00 -0700...2015-10-22 00:00:00 -0700
    # Note that the range excludes its end value as indicated by
    # "...".

Example B:

    # Derive a frame composed of year, day-of-year, and
    # hour-of-day from a Time value.
    
    frame_type = TimeScales[:year, :day, :hour]
    frame = frame_type & Time.new(2011,6,25 , 13,15)
    
    puts(
      frame.year_of_scheme,
      frame.day_of_year,
      frame.hour_of_day,
    )
    # == Output ==
    # 2011
    # 176
    # 13

Example C:

    # Determine whether a date falls within a particular month
    # of a particular quarter of its year.

    frame_type = TimeScales[:quarter, :month]
    some_time = Time.new(2011,10,31 , 12,00)
    
    puts frame_type & some_time == frame_type.new(3, 1)
    # Output: false
    
    puts frame_type & some_time == frame_type.new(4, 1)
    # Output: true

A frame type consists of a number of parts, each of which has a
scope unit and a subdivision unit. The frame type has an outer
scope (the scope of its largest part) and a precision (the
subdivision of its smallest part).

In order to be a valid set of parts for a frame type, it must be
possible to form a chain of parts such that the scope unit of a
smaller part is the same as the subdivision unit of a larger
part. It is possible to specify a part by its subdivision unit
if there is any such part that will properly chain to the next
larger part. When a unit specifies the largest part for a frame
type, then it refers to the unit's default part (e.g. DayOfMonth
for Day).

Of the available units, the Scheme unit is special. Scheme refers
to the date/time scheme of the time values that a frame can be
built from or converted into. There can never be a unit larger
than Scheme, and Scheme can only be the outer scope of a frame
type. Also, only a frame instance with a Scheme-scoped type (a
specific type) can be converted into a Time value.

The available units are…
* `TimeScales::Units::Scheme` (`:scheme`)
* `TimeScales::Units::Year` (`:year`)
* `TimeScales::Units::Quarter` (`:quarter`)
* `TimeScales::Units::Month` (`:month`)
* `TimeScales::Units::Day` (`:day`)
* `TimeScales::Units::Hour` (`:hour`)
* `TimeScales::Units::Hour` (`:minute`)

The available frame parts are…
* `TimeScales::Parts::YearOfScheme` (`:year_of_scheme`, default for `Year`)
* `TimeScales::Parts::QuarterOfyear` (`:quarter_of_year`, default for `Quarter`)
* `TimeScales::Parts::MonthOfYear` (`:month_of_year`, default for `Year`)
* `TimeScales::Parts::MonthOfQuarter` (`:month_of_quarter`)
* `TimeScales::Parts::DayOfMonth` (`:day_of_month`, default for `Day`)
* `TimeScales::Parts::DayOfYear` (`:day_of_year`)
* `TimeScales::Parts::DayOfQuarter` (`:day_of_quarter`)
* `TimeScales::Parts::HourOfDay` (`:hour_of_day`, default for `Hour`)
* `TimeScales::Parts::MinuteOfHour` (`:minute_of_hour`, default for `Minute`)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run
`bundle exec rake install`. To release a new version, update the version
number in `version.rb`, and then run `bundle exec rake release` to create a
git tag for the version, push git commits and tags, and push the `.gem`
file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/time_scales/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
