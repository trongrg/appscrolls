require 'appscrolls'
require 'thor'

module AppScrolls
  class Command < Thor
    include Thor::Actions

    desc "version", "show version of currently installed AppScrolls gem"
    def version
      puts "AppScrolls version #{AppScrolls::VERSION} ready to make magic."
    end

    desc "new APP_NAME", "create a new Rails app"
    method_option :scrolls, :type => :array, :aliases => "-s", :desc => "List scrolls, e.g. -s resque rails_basics jquery"
    def new(name)
      if options[:scrolls]
        run_template(name, options[:scrolls])
      else
        run_template(name, interactive_scrolls("#{bold}Which scroll would you like to add/remove? #{clear}#{yellow}(blank to finish)#{clear}"))
      end
    end

    desc "list [CATEGORY]", "list available scrolls (optionally by category)"
    def list(category = nil)
      if category
        scrolls = AppScrolls::Scrolls.for(category).map{|r| AppScrolls::Scroll.from_mongo(r) }
      else
        scrolls = AppScrolls::Scrolls.list_classes
      end

      scrolls.each do |scroll|
        puts scroll.key.ljust(15) + "# #{scroll.description}"
      end
    end

    desc "add scrolls", "add more scrolls to existing Rails app"
    method_option :scrolls, :type => :array, :aliases => "-s", :desc => "List scrolls, e.g. -s resque rails_basics jquery"
    def add
      return unless rails_app?
      scrolls = options[:scrolls]
      puts "\n\n#{bold}Generating and Running Template...#{clear}\n"
      template = create_template(scrolls)
      file_name = "lib/generators/app_scrolls/app_scrolls_generator.rb"
      FileUtils.mkdir_p(File.dirname(file_name))
      File.open(file_name, 'w') { |f| f.write template.compile }
      inject_into_file file_name, """
class AppScrollsGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  def add
""", :after => "# END MODULE\n"
      append_file file_name, "\nend\nend"
      run "rails g app_scrolls add"
    end

    no_tasks do
      def cyan; "\033[36m" end
      def clear; "\033[0m" end
      def bold; "\033[1m" end
      def red; "\033[31m" end
      def green; "\033[32m" end
      def yellow; "\033[33m" end

      def scrolls_message(scrolls)
        message = "\n\n\n"
        if scrolls && scrolls.any?
          message << "#{green}#{bold}Your Scrolls:#{clear} #{scrolls.join(", ")}\n\n"
        end
        available_scrolls = AppScrolls::Scrolls.list - scrolls
        if available_scrolls.any?
          message << "#{bold}#{cyan}Available Scrolls:#{clear} #{available_scrolls.join(', ')}\n\n"
        end
        message
      end

      def run_template(name, scrolls)
        puts "\n\n#{bold}Generating and Running Template...#{clear}\n\n"
        template = create_template(scrolls)
        file = Tempfile.new('template')
        file.write template.compile
        system "rails new #{name} -m #{file.path} #{template.args.join(' ')}"
      end

      def create_template(scrolls)
        template = AppScrolls::Template.new(scrolls)

        puts "Using the following scrolls:"
        template.resolve_scrolls.map do |scroll|
          color = scrolls.include?(scroll.new.key) ? green : yellow # yellow - automatic dependency
          puts "  #{color}* #{scroll.new.name}#{clear}"
        end
        template
      end

      def rails_app?
        if File.read("Gemfile").include?("rails")
          true
        else
          puts "Not a Rails application"
          false
        end
      end

      def interactive_scrolls(question, scrolls = [])
        if (scroll = ask(scrolls_message(scrolls) + question)) == ''
          return scrolls
        elsif scrolls.include?(scroll)
          scrolls.delete(scroll)
          puts "\n> #{yellow}Removed '#{scroll}' from template.#{clear}"
        elsif AppScrolls::Scrolls.list.include?(scroll)
          scrolls << scroll
          puts "\n> #{green}Added '#{scroll}' to template.#{clear}"
        end
        interactive_scrolls(question, scrolls)
      end
    end
  end
end
