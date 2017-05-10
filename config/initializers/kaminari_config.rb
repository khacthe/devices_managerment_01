# frozen_string_literal: true
Kaminari.configure do |config|
  config.default_per_page = Settings.view.device.per_page
  config.page_method_name = :page
  config.param_name = :page
end
