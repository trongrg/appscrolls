gem 'vcr', :group => :test
gem 'fakeweb', :group => :test

after_everything do
  content = <<-RUBY
require 'vcr'
VCR.configure do |c|
  c.default_cassette_options = { :record => :new_episodes, :erb => true }
  c.allow_http_connections_when_no_cassette = tru
  c.cassette_library_dir = 'vcr_cassettes'
  c.hook_into :fakeweb
  c.ignore_localhost = true
end
RUBY

  if scroll?('rspec')
    create_file "spec/support/vcr.rb", content
    inject_into_file 'spec/support/vcr.rb', "\n  c.configure_rspec_metadata!\n", :before => "end"
    inject_into_file 'spec/spec_helper.rb', "\n  config.treat_symbols_as_metadata_keys_with_true_values = true\n", :after => "Rspec.configure do |config|"
  end

  if scroll?('cucumber')
    create_file "features/support/vcr.rb", content
    append_file "features/support/vcr.rb", <<-RUBY
VCR.cucumber_tags do |t|
  t.tag  '@vcr', :use_scenario_name => true
end
RUBY
  end
end

__END__

name: Vcr
description: Record your test suite's HTTP interactions and replay them
website: https://relishapp.com/vcr/vcr/docs
author: trongtran

requires: []
run_after: [rspec, cucumber]
run_before: []

category: other # authentication, testing, persistence, javascript, css, services, deployment, and templating
# exclusive:

# config:
#   - foo:
#       type: boolean
#       prompt: "Is foo true?"
