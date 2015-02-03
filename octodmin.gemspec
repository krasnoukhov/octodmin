# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "octodmin/version"

Gem::Specification.new do |spec|
  spec.name          = "octodmin"
  spec.version       = Octodmin::VERSION
  spec.authors       = ["Dmitry Krasnoukhov"]
  spec.email         = ["dmitry@krasnoukhov.com"]
  spec.summary       = spec.description = %q{Web GUI for Jekyll/Octopress blogs}
  spec.homepage      = "https://github.com/krasnoukhov/octodmin"
  spec.license       = "MIT"

  spec.files         = (`git ls-files -z`.split("\x0") + `find app`.split("\n")).uniq
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "octopress", ">= 3.0.0.rc"
  spec.add_runtime_dependency "lotusrb", ">= 0.2.0"
end
