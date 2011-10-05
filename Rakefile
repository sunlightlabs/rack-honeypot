
require 'jeweler'
require 'rake/testtask'

Rake::TestTask.new do |task|
  task.test_files = FileList['test/test_*.rb']
end

Jeweler::Tasks.new do |gem|
  gem.name = "rack-honeypot"
  gem.summary = %Q{Middleware that functions as a spambot trap.}
  gem.description = %Q{This middleware acts as a spam trap. It inserts, into every outputted <form>, a text field that a spambot will really want to fill in, but is actually not used by the app. The field is hidden to humans via CSS, and includes a warning label for screenreading software.}
  gem.email = "daniel.schierbeck@gmail.com"
  gem.homepage = "http://github.com/dasch/rack-honeypot"
  gem.authors = ["Luigi Montanez", "Luc Castera", "Daniel Schierbeck"]
end
Jeweler::RubygemsDotOrgTasks.new
