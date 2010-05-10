require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tm4r'

Rake::RDocTask.new("doc") do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = "TM4R, aka Topic Maps for Ruby"
  rdoc.rdoc_files.include('README')
  rdoc.options << '--line-numbers'
  rdoc.options << '--inline-source'
  rdoc.options << '--main' << 'README'
  rdoc.rdoc_files.include("lib/**/*.rb")
end


Rake::TestTask.new("test") do |t|
  t.pattern = 'test/*.rb'
  t.verbose = true
  t.warning = true
end

task :test => [:environment]

task :default => [:test]

task :migrate  => :environment do
  ActiveRecord::Migrator.migrate('lib/tm4r/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :environment do
  $stderr << "in environment\n"
  ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))
  ActiveRecord::Base.establish_connection(YAML::load(File.open('lib/database.yaml')))
  #ActiveRecord::Base.colorize_logging = false
end



desc "List all lines with TODO, FIXME or XXX in ruby source files"
task :todo do
  FileList.new("**/*.rb").each do |source|
    File.open(source) do |f|
      f.each_line do |line|
        puts "#{source}, #{f.lineno}: #{line.strip}" if line =~ /(FIXME|TODO|XXX)/
      end
    end
  end
end

