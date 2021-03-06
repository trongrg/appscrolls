gem 'machinist', :group => :test

inject_into_file "config/initializers/generators.rb", :after => "Rails.application.config.generators do |g|\n" do
  "    g.fixture_replacement :machinist\n"
end

after_bundler do
  generate "machinist:install"
end
__END__

name: Machinist
description: Makes it easy to create objects for use in tests
website: https://github.com/notahat/machinist
author: trongtran

requires: []
run_after: []
run_before: []

category: testing # authentication, testing, persistence, javascript, css, services, deployment, and templating
