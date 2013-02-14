gem 'squeel'

after_bundler do
  generate 'squeel:initializer'
end

__END__

name: Squeel
description: Squeel lets you write your Active Record queries with fewer strings, and more Ruby
website: https://github.com/ernie/squeel
author: trongtran

category: other # authentication, testing, persistence, javascript, css, services, deployment, and templating
