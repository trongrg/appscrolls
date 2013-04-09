append_file 'Gemfile', "\ngem 'spork', :git => 'git@github.com:sporkrb/spork.git'"

after_bundler do
  run "bundle exec spork --bootstrap"
  run "bundle exec spork cucumber --bootstrap" if scroll? 'cucumber'
end

__END__

name: Spork
description: DRb server for testing frameworks that forks before each run to ensure a clean testing state
author: drnic
website: https://github.com/sporkrb/spork

requires: []
run_after: []
run_before: []

category: testing
# exclusive:
