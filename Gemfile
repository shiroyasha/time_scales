source 'https://rubygems.org'

# These development dependencies are temporarily
# loaded from here in Gemfile because they have
# to come from github, and I can't figure out how
# to do that in the gemspec file.
%w[rspec rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
  gem lib, :git => "git://github.com/rspec/#{lib}.git"
end

# Specify your gem's dependencies in time_scales.gemspec
gemspec
