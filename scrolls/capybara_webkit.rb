gem 'capybara-webkit', :group => [:test]

after_bundler do
  content = <<-RUBY
  require 'capybara-webkit'
  Capybara.javascript_driver = :webkit
RUBY
  append_file("features/support/capybara.rb", content) if scroll?("cucumber")
  append_file "spec/support/capybara.rb", content if scroll?("rspec")
end

__END__

name: CapybaraWebkit
description: Use webkit driver for capybara
author: trongrg
requires: [capybara]
run_after: [capybara]
category: testing

