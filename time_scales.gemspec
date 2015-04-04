# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'time_scales/version'

Gem::Specification.new do |spec|
  spec.name          = "time_scales"
  spec.version       = TimeScales::VERSION
  spec.authors       = ["Steve Jorgensen"]
  spec.email         = ["stevej@stevej.name"]

  spec.summary       = "Date/Time representations with specific scopes, units, and precisions"
  spec.homepage      = "https://github.com/stevecj/time_scales"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.required_ruby_version = ">= 1.9"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"

  # rspec is temporarily being required via the
  # Gemfile since we need a pre-release version that
  # is still only available via Github.
  #spec.add_development_dependency "rspec", "~> 3.3.0"
end
