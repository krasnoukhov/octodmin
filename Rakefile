require "bundler"
Bundler.require

require "fileutils"
require "rspec/core/rake_task"
require "bundler/gem_tasks"
require "sprockets/standalone"

# Test tasks
RSpec::Core::RakeTask.new(:spec)

namespace :spec do
  task :coverage do
    ENV["COVERAGE"] = "true"
    Rake::Task["spec"].invoke
  end
end

task default: :spec

# Release tasks
Sprockets::Standalone::RakeTask.new(:assets) do |task, sprockets|
  require_relative "app/config/sprockets"

  task.assets   = %w(app.js app.css *.eot *.svg *.ttf *.woff *woff2)
  task.sources  = %w(app/assets)
  task.output   = "app/public/assets"
  task.compress = true
  task.digest   = false
  task.environment = Octodmin.sprockets
end

namespace :assets do
  task :remove do
    FileUtils.rm_r("./app/public/assets", force: true)
  end
end

Rake::Task["build"].enhance([:"assets:remove", :"assets:compile"])
