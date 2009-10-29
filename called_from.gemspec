require 'rubygems' unless defined?(Gem)

spec = Gem::Specification.new do |s|
  s.name     = "called_from"
  s.author   = "makoto kuata"
  s.email    = "kwa.at.kuwata-lab.com"
  s.version  = "$Release$"
  s.date     = "$Date$"
  #s.platform = Gem::Platform::RUBY
  s.homepage = "http://github.com/kwatch/called_from/"
  s.summary  = "much faster of caller()[0]"
  s.rubyforge_project = "called_from"
  s.description = <<END
Extention Module 'called_from' provides called_from() global function
which gets filename and line number of caller.

In short:

    require 'called_from'
    filename, linenum, function = called_from(1)

is equivarent to:

    caller(1)[0] =~ /:(\d+)( in `(.*)')?/
    filename, linenum, function = $`, $1, $2

But called_from() is much faster than caller()[0].
END
  s.files = []
  s.files += %w[README.txt Rakefile setup.rb called_from.gemspec]
  s.files += Dir.glob("ext/**/*")
  s.files += Dir.glob("lib/**/*")
  s.files += Dir.glob("test/**/*")
  s.files += %w[benchapp.zip]
  #s.test_file  = "test/test_called_from.rb"
  s.extensions = ["ext/called_from/extconf.rb"]
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
end

if $0 == __FILE__
  #Gem::manage_gems
  #Gem::Builder.new(spec).build
  require 'rubygems/gem_runner'
  Gem::GemRunner.new.run ['build', 'called_from.gemspec']
end

spec
