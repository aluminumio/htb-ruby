# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "htb"
  spec.version       = "0.1.0"
  spec.authors       = ["usiegj00"]
  spec.email         = ["usiegj00@users.noreply.github.com"]

  spec.summary       = "Ruby client for the Hack The Box API v4"
  spec.description   = "A Ruby gem for interacting with the Hack The Box (HTB) API v4. " \
                       "Supports machine management, user profiles, VM spawning, flag submission, and more."
  spec.homepage      = "https://github.com/aluminumio/htb-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/aluminumio/htb-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/aluminumio/htb-ruby/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "faraday-multipart", "~> 1.0"
  spec.add_dependency "thor", "~> 1.0"
  spec.add_dependency "tty-table", "~> 0.12"
  spec.add_dependency "tty-spinner", "~> 0.9"
  spec.add_dependency "tty-prompt", "~> 0.23"
  spec.add_dependency "pastel", "~> 0.8"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.0"
end
