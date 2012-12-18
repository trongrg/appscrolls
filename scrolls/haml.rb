gem 'haml-rails'

inject_into_file "config/initializers/generators.rb", :after => "Rails.application.config.generators do |g|\n" do
  "    g.template_engine :haml\n"
end

after_bundler do
  remove_file "app/views/layouts/application.html.erb"
  create_file "app/views/layouts/application.html.haml", <<-RUBY
!!!
%html
  %head
    %meta{:charset => 'utf-8'}
    %title #{app_name}
    = csrf_meta_tag
    = stylesheet_link_tag "application", :media => "all"
    = javascript_include_tag "application"
  %body
    = yield
  RUBY
end

__END__

name: HAML
description: "Utilize HAML for templating."

category: templating
exclusive: templating
