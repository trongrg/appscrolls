require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']

if config['guard_notifications']
  gem_group :development do
    case HOST_OS
    when /darwin/i
      gem 'rb-fsevent'
      mac_osx_version  = /(10\.\d+)(\.\d+)?/.match(`/usr/bin/sw_vers -productVersion`.chomp).captures.first.to_f
      if 10.8 <= mac_osx_version # Actually Mountain Lion or newer
        gem 'terminal-notifier-guard'
      else
        gem 'ruby_gntp'
      end
    when /linux/i
      gem 'libnotify'
      gem 'rb-inotify'
    when /mswin|windows/i
      gem 'rb-fchange'
      gem 'win32console'
      gem 'rb-notifu'
    end
  end
end


# LiveReload

application nil, :env => "development" do
  "config.middleware.insert_before(Rack::Lock, Rack::LiveReload)"
end


gem_group :development do
  gem 'guard-livereload'
  gem 'yajl-ruby'
  gem 'rack-livereload'

  # Guard for other Scrolls

  gem 'guard-bundler'
  gem 'guard-test' if scrolls.include? 'test_unit'

  KNOWN_GUARD_SCROLLS = %w[cucumber haml less passenger puma redis resque rspec spork unicorn]
  KNOWN_GUARD_SCROLLS.each do |scroll|
    gem "guard-#{scroll}" if scrolls.include? scroll
  end
end

after_bundler do
  KNOWN_GUARD = %w[livereload bundler spork cucumber rspec test haml less passenger puma redis resque unicorn]
  run "bundle exec guard init #{KNOWN_GUARD.join(" ")}"
end

after_everything do
  if scroll? 'spork'
    gsub_file 'Guardfile', "guard 'cucumber' do", "guard 'cucumber', :cli => '--drb' do"
    gsub_file 'Guardfile', "guard 'rspec' do", "guard 'rspec', :cli => '--drb' do"
    gsub_file 'Guardfile', "watch(%r{features/support/}) { :cucumber }", "watch('features/support/env.rb') { :cucumber }"
    inject_into_file 'Guardfile', "\n  watch('app/controllers/application_controller.rb')", :after => "watch('features/support/env.rb') { :cucumber }"
  end
end

__END__

name: Guard
description: Command line tool to file system modification events; Powers Up with other scrolls!
author: drnic
website: https://github.com/guard/guard

requires: []
run_after: []
run_before: []

category: other
# exclusive:

config:
  - guard_notifications:
      type: boolean
      prompt: "Enable desktop Guard/Growl notifications?"
