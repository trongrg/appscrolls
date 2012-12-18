gem 'bootstrap-sass', '~> 2.2.1.1', :group => :assets

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
description:
website:
author: trongtran

run_after: [haml, sass]

category: css # authentication, testing, persistence, javascript, css, services, deployment, and templating
# exclusive:

# config:
#   - foo:
#       type: boolean
#       prompt: "Is foo true?"

