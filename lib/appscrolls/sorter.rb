require 'tsort'
module AppScrolls
  class Sorter
    include TSort

    def initialize(scrolls)
      @scrolls = scrolls
    end

    def tsort_each_node(&block)
      @scrolls.each(&block)
    end

    def tsort_each_child(scroll, &block)
      @scrolls.select { |i| i.run_before?(scroll) || scroll.run_after?(i) }.each(&block)
    end
  end
end
