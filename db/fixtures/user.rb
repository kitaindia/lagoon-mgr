User.seed do |s|
  s.id = 1
  s.username = "admin"
  s.email    = "admin@example.com"
  s.password = ENV['ADMIN_PASSWORD']
  s.is_admin = true
end
