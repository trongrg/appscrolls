gem 'acts-as-taggable-on', '~> 2.3.1'

after_bundler do
  generate "acts_as_taggable_on:migration"
end

__END__

name: Acts as taggable on
description: Allows custom tagging along dynamic contexts
website: https://github.com/mbleigh/acts-as-taggable-on
author: trongtran

category: other # authentication, testing, persistence, javascript, css, services, deployment, and templating
# exclusive:

# config:
#   - foo:
#       type: boolean
#       prompt: "Is foo true?"
