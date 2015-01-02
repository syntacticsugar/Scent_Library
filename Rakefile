require 'rspec/core/rake_task'
require 'launchy'

RSpec::Core::RakeTask.new :spec do |task|
  task.rspec_opts = ["-r ./spec/spec_helper"]
end

task default: :spec

desc "View generated test coverage stats"
task :"view-coverage" do
  Launchy.open File.expand_path("coverage/index.html", File.dirname(__FILE__))
end
