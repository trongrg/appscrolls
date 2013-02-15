gem 'kaminari'

after_bundler do
  generate "kaminari:config"
  generate "kaminari:views#{' bootstrap' if scroll?('bootstrap_sass')}#{' -e haml' if scroll?('haml')}"
end

__END__

name: Kaminari
description: A Scope & Engine based, clean, powerful, customizable and sophisticated paginator
website: https://github.com/amatsuda/kaminari
author: trongtran

category: templating # authentication, testing, persistence, javascript, css, services, deployment, and templating
