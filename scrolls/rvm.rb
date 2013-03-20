before_everything do
  gemset = config['gemset'].present? ? config['gemset'] : app_name
  ruby_version = config['ruby_version'].present? ? config['ruby_version'] : '2.0.0'
  create_file '.ruby-version', <<-END
ruby-#{ruby_version}
END

  create_file '.ruby-gemset', gemset

  run 'rvm rvmrc trust .'
  run 'source .rvmrc'
end

__END__

name: RVM
description: Creates .rvmrc file and gemset
category: other
config:
  - gemset:
      prompt: "Specify gemset for RVM:"
      type: string
  - ruby_version:
      prompt: "Specify ruby version for RVM (default to 2.0.0):"
      type: string
