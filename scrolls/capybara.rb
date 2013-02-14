gem 'capybara', :group => [:test]

after_bundler do
  create_file "spec/support/capybara.rb", <<-RUBY
require 'capybara/rails'
require 'capybara/rspec'
RUBY

  if scroll?("cucumber")
    create_file "features/support/capybara.rb", <<-RUBY
require 'capybara/rails'
require 'capybara/cucumber'
require 'capybara/session'
RUBY
  end
end

__END__

name: Capybara
description: "Use the Capybara acceptance testing libraries with RSpec."
author: mbleigh

requires: [rspec]
run_after: [rspec, cucumber]
exclusive: acceptance_testing
category: testing
tags: [acceptance]
