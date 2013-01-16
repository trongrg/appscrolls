before_everything do
  gemset = config['gemset'].present? ? config['gemset'] : app_name
  create_file '.rvmrc', <<-END
  rvm use 2.0.0@#{gemset} --create
  END

  run 'rvm rvmrc trust .'
  run 'source .rvmrc'
end

__END__
name: RVM
description: Creates .rvmrc file and gemset
category: other
config:
  - gemset:
      prompt: "Specify gemset for RVM file:"
      type: string
