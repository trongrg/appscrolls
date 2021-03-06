gem 'bootstrap-sass', :group => :assets

after_bundler do
  create_file "app/assets/stylesheets/app_bootstrap.css.scss", <<-SCSS
// change colors
//$linkColor: red;

// change grid
//$gridColumnWidth: 70px;
//$gridGutterWidth: 10px;
@import "bootstrap";
SCSS

  append_file "app/assets/stylesheets/application.css.scss", <<-CSS
@import "app_bootstrap";
CSS

  append_file "app/assets/javascripts/application.js", <<-JS
//= require bootstrap
JS

  if File.exists? "app/views/layouts/application.html.erb"
  gsub_file "app/views/layouts/application.html.erb", /\<body\>/, <<-HTML
  <body>
<% flash.each do |name, msg| %>
        <div class="alert alert-<%= name == :notice ? "success" : "error" %>">
          <a class="close" data-dismiss="alert">×</a>
          <%= msg %>
        </div>
      <% end %>
HTML
  elsif File.exists? "app/views/layouts/application.html.haml"
  gsub_file "app/views/layouts/application.html.haml", /%body/, %q{
  %body
    #flash
      - flash.each do |name, msg|
        - if msg.is_a?(String)
          %div{:class => "alert alert-#{name == :notice ? "success" : "error"}"}
            %a.close{"data-dismiss" => "alert"} ×
            = content_tag :div, msg, :id => "flash_#{name}"
  }
  end

end

__END__

name: Bootstrap-sass
description: Use Sass-powered twitter-bootstrap
website: https://github.com/thomas-mcdonald/bootstrap-sass
author: trongtran

requires: [sass]
run_after: [haml, sass]

category: assets
tag: [css, stylesheets, javascripts]
