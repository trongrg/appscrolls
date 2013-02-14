gem 'compass-rails', :group => :assets

after_bundler do
  prepend_file "app/assets/stylesheets/application.css.scss", <<-SCSS
// Import compass
@import "compass";
SCSS
end

__END__

name: Compass
description: "Use Compass Stylesheet Authoring Framework for Ruby on Rails."

requires: [sass]
run_after: [sass]

category: assets
tags: [css, stylesheet]
