require 'appscrolls/scrolls'
require 'appscrolls/scroll'
require 'appscrolls/config'
require 'appscrolls/template'
require 'appscrolls/sorter'

def enroll_scroll_at(path)
  key = File.basename(path, '.rb')
  scroll_class_name = ActiveSupport::Inflector.camelize(key.gsub("-", "_"))

  # default files of same keys as local scrolls are discarded
  return if AppScrolls::Scrolls.const_defined?(scroll_class_name)

  scroll = AppScrolls::Scroll.generate(key, File.open(path))
  AppScrolls::Scrolls.add(scroll)
end

# set up local scrolls if available
if dir = ENV['APPSCROLLS_DIR'] and dir != ""
  (Dir[dir + '/*.rb'] + Dir[dir + '/**/*.rb']).each do |path|
    enroll_scroll_at(path)
  end
end

Dir[File.dirname(__FILE__) + '/../scrolls/*.rb'].each do |path|
  enroll_scroll_at(path)
end
