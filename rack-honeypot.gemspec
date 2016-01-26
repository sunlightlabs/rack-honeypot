Gem::Specification.new do |s|
  s.name = %q{rack-honeypot}
  s.version = "0.1.2"
  s.summary = %q{Middleware that functions as a spambot trap.}
  s.authors = ["Luigi Montanez", "Luc Castera", "Daniel Schierbeck"]
  s.date = %q{2011-10-05}
  s.description = %q{This middleware acts as a spam trap. It inserts, into every outputted <form>, a text field that a spambot will really want to fill in, but is actually not used by the app. The field is hidden to humans via CSS, and includes a warning label for screenreading software.}
  s.email = %q{luigi.montanez@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.md",
    "README.md"
  ]
  s.files = [
    "LICENSE.md",
    "README.md",
    "VERSION",
    "lib/rack/honeypot.rb"
  ]

  s.homepage = %q{http://github.com/sunlightlabs/rack-honeypot}
  s.require_paths = ["lib"]

  s.add_dependency(%q<unindentable>, ["= 0.0.4"])
  s.add_dependency(%q<rack>, [">= 0"])
  s.add_development_dependency('rack-test')
end

