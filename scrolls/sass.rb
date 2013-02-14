# gem 'sass-rails' # No longer needed because it's included by default

after_bundler do
run "rm app/assets/stylesheets/application.css"

create_file "app/assets/stylesheets/_variables.css.scss", <<-END
// Define your global Sass variables here, for example:
// $black: #000 !default;
END

create_file "app/assets/stylesheets/application.css.scss", <<-RUBY
// Import any Sass/SCSS files you need below.
@import "variables";
RUBY
end

__END__

name: SASS
description: "Utilize SASS for really awesome stylesheets!"
author: mbleigh

category: assets
tags: [css, stylesheet]
