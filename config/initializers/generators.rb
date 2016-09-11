Rails.application.config.generators do |g|
  g.orm :active_record
  g.test_framework :rspec, fixture: true, fixture_replacement: :factory_girl
  g.view_specs false
  g.routing_specs false
  g.helper_specs false
  g.request_specs false
  g.assets false
  g.helper false
end
