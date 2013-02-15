gem 'rspec-rails', '~> 2.0', :group => [:development, :test]
gem 'rspec-instafail', :group => :test

after_bundler do
  generate 'rspec:install'
end

after_everything do
  inject_into_file "config/initializers/generators.rb", :after => "Rails.application.config.generators do |g|\n" do
    "    g.test_framework = :rspec\n"
  end

  append_file '.rspec', <<-RSPEC
--require rspec/instafail
--format RSpec::Instafail
RSPEC
end

__END__

name: RSpec
description: "Use RSpec for unit testing for this Rails app."
author: mbleigh

exclusive: unit_testing
category: testing

args: ["-T"]

