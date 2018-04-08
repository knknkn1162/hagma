
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hagma/version'

Gem::Specification.new do |spec|
  spec.name          = 'hagma'
  spec.version       = Hagma::VERSION
  spec.authors       = ['knknkn']
  spec.email         = ['knknkn1162@gmail.com']

  spec.summary       = 'track the module, class and definition'
  spec.description   = 'track the module, class and definition (under development)'
  spec.homepage      = 'https://github.com/knknkn1162'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter'
end
