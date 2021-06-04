require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require_relative 'lib/sts2mn/version'
require 'open-uri'

RSpec::Core::RakeTask.new(:spec)

task :default => ['bin/sts2mn.jar', 'spec/fixtures/rice-en.final.sts.xml', :spec]

file 'bin/sts2mn.jar' do |file|
  ver = Sts2mn::STS2MN_JAR_VERSION
  url = "https://github.com/metanorma/sts2mn/releases/download/v#{ver}/sts2mn-#{ver}.jar"
  File.open(file.name, 'wb') do |file|
    file.write URI.open(url).read
  end
end

file 'spec/fixtures/rice-en.final.sts.xml' do |file|
  uri = "https://raw.githubusercontent.com/metanorma/sts2mn/master/src/test/resources/rice-en.final.sts.xml"

  File.open(file.name, "w") do |saved_file|
    # the following "open" is provided by open-uri
    saved_file.write(URI.open(uri, "r").read)
  end
end
