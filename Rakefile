require 'rake/testtask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the Stripped Attributes plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
end

begin
  require 'hanna/rdoctask'
rescue LoadError
  require 'rake/rdoctask'
end

desc 'Generate documentation for the Stripped Attributes plugin.'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = "Stripped Attributes"
  rdoc.main = "README.rdoc"
 
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.options << '--charset' << 'utf-8'
  
  rdoc.rdoc_files.include 'README.rdoc'
  rdoc.rdoc_files.include 'MIT-LICENSE'
  rdoc.rdoc_files.include 'CHANGELOG.rdoc'
  rdoc.rdoc_files.include 'lib/**/*.rb'
  rdoc.rdoc_files.exclude 'lib/stripped_attributes/version.rb'
end

namespace :rdoc do
  desc 'Show documentation in Firefox'
  task :show do
    sh 'firefox doc/index.html'
  end
end

