require 'spec_helper'

describe AppScrolls::Template do
  subject{ AppScrolls::Template }
  let(:scroll){ AppScrolls::Scroll.generate('name','# test') }

  describe '#initialize' do
    it 'should work with classes' do
      subject.new([scroll]).scrolls.should == [scroll]
    end
  end

  describe '#scrolls_with_dependencies' do
    def s(*deps)
      mock(:Class, :requires => deps, :superclass => AppScrolls::Scroll)
    end

    def scroll(name)
      AppScrolls::Scrolls[name]
    end

    subject do
      @template = AppScrolls::Template.new([])
      @template.stub!(:scrolls).and_return(@scrolls)
      @template.stub!(:scroll_classes).and_return(@scrolls)
      @template
    end

    it 'should return the same number scrolls if none have dependencies' do
      @scrolls = [s, s]
      subject.scrolls_with_dependencies.size.should == 2
    end

    it 'should handle simple dependencies' do
      @scrolls = [s(s, s), s(s)]
      subject.scrolls_with_dependencies.size.should == 5
    end

    it 'should handle multi-level dependencies' do
      @scrolls = [s(s(s))]
      subject.scrolls_with_dependencies.size.should == 3
    end

    it 'should uniqify' do
      a = s
      b = s(a)
      c = s(s, a, b)
      @scrolls = [a,b,c]
      subject.scrolls_with_dependencies.size.should == 4
    end

  end

  describe "#resolve_scrolls" do
    def scroll(name, attributes = {})
      attributes = {:requires => [], :run_after => [], :run_before => []}.merge(attributes)
      AppScrolls::Scrolls.add(AppScrolls::Scroll.generate(name, '# test', attributes))
      AppScrolls::Scrolls[name]
    end

    before do
      @a = scroll('b')
      @b = scroll('c', :requires => ['b'], :run_after => ['b'])
      @c = scroll('d')
      @d = scroll('a', :requires => ['d'], :run_after => ['d'])
      @scrolls = [@b, @d]
    end

    let(:subject) { AppScrolls::Template.new(@scrolls) }

    it 'should resolve scrolls' do
      subject.resolve_scrolls.size.should == 4
    end

    it 'should sort scrolls' do
      resolve_scrolls = subject.resolve_scrolls
      resolve_scrolls.index(@a).should < resolve_scrolls.index(@b)
      resolve_scrolls.index(@c).should < resolve_scrolls.index(@d)
    end
  end
end
