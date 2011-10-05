Gem::Specification.new do |s|
  s.name = %q{rack-honeypot}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Luigi Montanez", "Luc Castera", "Daniel Schierbeck"]
  s.date = %q{2011-10-05}
  s.description = %q{This middleware acts as a spam trap. It inserts, into every outputted <form>, a text field that a spambot will really want to fill in, but is actually not used by the app. The field is hidden to humans via CSS, and includes a warning label for screenreading software.}
  s.email = %q{luigi.montanez@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.md",
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "LICENSE.md",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/rack/honeypot.rb",
    "test/test_honeypot.rb"
  ]
  s.homepage = %q{http://github.com/sunlightlabs/rack-honeypot}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.3}
  s.summary = %q{Middleware that functions as a spambot trap.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<unindentable>, ["= 0.0.4"])
      s.add_runtime_dependency(%q<rack>, [">= 0"])
      s.add_runtime_dependency(%q<rack-test>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<unindentable>, ["= 0.0.4"])
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<unindentable>, ["= 0.0.4"])
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
  end
end

