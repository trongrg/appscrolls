gem 'settingslogic'

say_wizard "Generating config/application.yml..."

create_file "config/application.yml", <<-YAML
defaults: &defaults
  cool:
    saweet: nested settings
  neat_setting: 24
  awesome_setting: <%= "Did you know 5 + 5 = #{5 + 5}?" %>

development:
  <<: *defaults
  neat_setting: 800

test:
  <<: *defaults

production:
  <<: *defaults
YAML


after_everything do
  append_file "config/application.rb", <<-RUBY

require 'settings'
  RUBY

  create_file "lib/settings.rb", <<-RUBY
class Settings < Settingslogic
  source "#\{Rails.root\}/config/application.yml"
  namespace Rails.env
end

  RUBY
end
__END__

name: Settingslogic
description: "A simple and straightforward settings solution that uses an ERB enabled YAML file and a singleton design pattern."
author: elandesign

category: other
tags: [utilities, configuration]
