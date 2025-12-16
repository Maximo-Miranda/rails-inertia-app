# frozen_string_literal: true

namespace :test do
  desc "Ensure Vite assets are built for test environment"
  task prepare_vite: :environment do
    cache_file = Rails.root.join("tmp/cache/vite/last-build-test.json")

    vite_built = cache_file.exist? && begin
      cache_data = JSON.parse(cache_file.read)
      cache_data["success"] == true
    rescue JSON::ParserError
      false
    end

    unless vite_built
      puts "Building Vite assets for test environment..."
      success = system("bin/vite build --mode test")
      abort("Vite build failed!") unless success
    end
  end
end

namespace :playwright do
  desc "Install Playwright browsers"
  task :install do
    puts "Installing Playwright browsers..."
    success = system("bunx playwright install firefox")
    abort("Playwright install failed!") unless success
  end
end
