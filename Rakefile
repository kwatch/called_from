require 'fileutils'

@project   = 'called_from'
@release   = '0.1.0'
@copyright = 'copyright(c) kuwata-lab.com all rights reserved.'
@license   = "Ruby's License"


task :default => [:test]

desc 'do test'
task :test do |t|
  #sh "testrb test/test_#{@project}.rb"
  sh "ruby test/test_#{@project}.rb"
end

desc 'call setup.rb config & setup'
task :build do |t|
  sh 'ruby setup.rb config'
  sh 'ruby setup.rb setup'
end

desc 'remove generated files'
task :clean do |t|
  sh 'ruby setup.rb clean'
  makefile = "ext/#{@project}/Makefile"
  rm_f makefile if File.exist? makefile
  rm_rf ['benchapp.zip', 'build']
  $:.each do |d|
    ['rb', 'bundle'].each do |suffix|
      fpath = "#{d}/#{@project}.#{suffix}"
      next unless File.file?(fpath)
      puts "*** remove #{File.basename(fpath)}"
      rm fpath
    end
  end
  sh 'gem uninstall called_from'
end

desc 'create package'
task :package do |t|
  base = "#{@project}-#{@release}"
  dir = "build/#{base}"
  rm_rf dir
  mkdir_p dir
  sh 'zip benchapp.zip benchapp'
  cp 'benchapp.zip', dir
  cp_r %w[ext lib test setup.rb Rakefile README.txt], dir
  cp_r "#{@project}.gemspec", dir
  Dir.glob("#{dir}/**/*").each do |fpath|
    next unless File.file?(fpath)
    s = File.open(fpath, 'rb') {|f| f.read }
    s.gsub! /\$Release\$/,     @release
    s.gsub! /\$Release:.*?\$/, "$Release: #{@release} $"
    s.gsub! /\$Copyright\$/,   @copyright
    s.gsub! /\$License\$/,     @license
    File.open(fpath, 'wb') {|f| f.write s }
  end
  chdir 'build' do
    sh "tar czf #{base}.tar.gz #{base}"
  end
  chdir "build/#{base}" do
    sh "ruby #{@project}.gemspec"
    mv "#{base}.gem", ".."
  end
end

desc "gem install #{@project}.gem"
task :'install-gem' do |t|
  chdir 'build' do
    base = "#{@project}-#{@release}"
    sh "gem install #{base}.gem"
  end
end

