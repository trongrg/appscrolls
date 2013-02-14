gem 'simple_form'
gem 'country_select'

after_bundler do
  if scroll?("twitter_bootstrap") || scroll?("bootstrap_sass")
    generate "simple_form:install --bootstrap"
  else
    generate "simple_form:install"
  end
end

__END__

name: Simple Form
description: Install Simple Form to generate nicely formatted forms.
author: jonochang
website: https://github.com/plataformatec/simple_form

exclusive: forms
category: templating
