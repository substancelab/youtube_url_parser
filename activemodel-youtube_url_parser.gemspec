Gem::Specification.new do |spec|
  spec.name = "activemodel-youtube_url_parser"
  spec.version = "1.0.0"
  spec.summary = "Parsing of youtube urls using rich activemodel"
  spec.authors = ["Ole Palm"]
  spec.email = "ole.palm@substancelab.com"
  spec.homepage = "https://github.com/substancelab/activemodel-email_address_validator"
  spec.license       = "MIT"
  spec.files = Dir["{lib}/*"] + ["Rakefile"]
  spec.require_paths = ["lib"]
  spec.add_dependency "activemodel", ">= 5.0", "< 8.0"
  spec.add_dependency "rack", ">= 2.0", "< 4.0"
  spec.add_dependency "uri", ">= 0.10", "< 4.0"
  spec.add_development_dependency "bundler", ">= 2.0"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "minitest"
end