# create rvmrc file
# create_file ".rvmrc", "rvm gemset create '#{app_name}' \nrvm gemset use '#{app_name}'"

gem "warbler" if jruby?

after_bundler do
  # clean up rails defaults
  remove_file "public/index.html"
  remove_file "public/images/rails.png"
  remove_file "app/assets/images/rails.png"
  generate "controller home index"
  gsub_file "app/controllers/home_controller.rb", /def index/, <<-RUBY
def index
    flash.now[:notice] = "Welcome! - love App Scrolls"
RUBY
  route "root :to => 'home#index'"

  run "mv README.rdoc RAILS_README.rdoc"
  remove_file "README.rdoc"
  create_file "README.md", <<-README
# ReadMe


## Deployment

```
ey deploy
```
Remove
## Thanks

The original scaffold for this application was created by [App Scrolls](http://appscrolls.org).

The project was created with the following scrolls:

#{ scrolls.map {|r| "* #{r}"}.join("\n")}

README

  if scroll? 'git'
    append_file ".gitignore", "\nconfig/database.yml"
    append_file ".gitignore", "\npublic/system"
    append_file ".gitignore", "\n.rvmrc"
  end

end

after_everything do
  rake "db:migrate"
end

__END__

name: Rails Basics
description: Best practices for new Rails apps
author: drnic
run_before: [git]
