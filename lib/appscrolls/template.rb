module AppScrolls
  class Template
    attr_reader :scrolls, :unknown_scroll_names, :config_script

    def initialize(scrolls, options={})
      @unknown_scroll_names = []
      @config_script = options[:config_script]
      @scrolls = scrolls.inject([]) do |list, name|
        scroll = AppScrolls::Scroll.from_mongo(name)
        if scroll
          list << scroll
        else
          @unknown_scroll_names << name
          $stderr.puts "Unknown scroll '#{name}'. Skipping."
        end
        list
      end
    end

    def self.template_root
      File.dirname(__FILE__) + '/../../templates'
    end

    def self.render(template_name, binding = nil)
      erb = ERB.new(File.open(template_root + '/' + template_name + '.erb').read)
      erb.result(binding)
    end
    def render(template_name, binding = nil); self.class.render(template_name, binding) end


    def resolve_scrolls
      # TODO: This doesn't work; replace with http://en.wikipedia.org/wiki/Topological_sorting
      @resolve_scrolls ||= scrolls_with_dependencies.sort.sort
    end

    def scroll_classes
      @scroll_classes ||= scrolls.map { |name| AppScrolls::Scroll.from_mongo(name) }
    end

    def scrolls_with_dependencies
      @scrolls_with_dependencies ||= scroll_classes
      
      added_more = false
      for scroll in scroll_classes
        scroll.requires.each do |requirement|
          requirement = AppScrolls::Scroll.from_mongo(requirement)
          count = @scrolls_with_dependencies.size
          (@scrolls_with_dependencies << requirement).uniq!
          unless @scrolls_with_dependencies.size == count
            added_more = true
          end
        end
      end

      added_more ? scrolls_with_dependencies : @scrolls_with_dependencies
    end

    def compile
      render 'layout', binding
    end

    def args
      scrolls.map(&:args).uniq
    end
    
    def custom_code?; false end
    def custom_code; nil end
  end
end
