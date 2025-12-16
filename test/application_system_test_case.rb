require "test_helper"
require "capybara"
require "capybara/minitest"
require "capybara-playwright-driver"

Capybara.register_driver(:playwright) do |app|
  Capybara::Playwright::Driver.new(app,
    browser_type: :firefox,
    headless: ENV.fetch("HEADLESS", "true") == "true",
    playwright_cli_executable_path: './node_modules/.bin/playwright'
  )
end

Capybara.default_driver = :playwright
Capybara.default_max_wait_time = 10
Capybara.app = Rails.application

class ApplicationSystemTestCase < ActiveSupport::TestCase
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  include Rails.application.routes.url_helpers

  # Cargar fixtures para los tests
  fixtures :all

  # Limpiar la sesión después de cada test
  def teardown
    Capybara.reset_sessions!
  end
end
