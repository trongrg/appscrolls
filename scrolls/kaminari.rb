gem 'kaminari'

after_bundler do
  generate "kaminari:config"
  view = "kaminari:view"
  view << " bootstrap" if scroll?("bootstrap_sass")
  view << " -e haml" if scroll?("haml")
  generate view
end

__END__

name: Kaminari
description: A Scope & Engine based, clean, powerful, customizable and sophisticated paginator
website: https://github.com/amatsuda/kaminari
author: trongtran

category: templating # authentication, testing, persistence, javascript, css, services, deployment, and templating
