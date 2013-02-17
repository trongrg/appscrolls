require 'active_support/ordered_hash'

module AppScrolls
  class Config
    attr_reader :questions

    def initialize(schema)
      @questions = ActiveSupport::OrderedHash.new
      schema.each do |hash|
        key = hash.keys.first
        details = hash.values.first

        kind = details['type']
        raise ArgumentError, "Unrecognized question type, must be one of #{QUESTION_TYPES.keys.join(', ')}" unless QUESTION_TYPES.keys.include?(kind)
        @questions[key] = QUESTION_TYPES[kind].new(details)
      end
    end

    def compile(values = {})
      result = []
      result << "config = #{values.inspect}"
      @questions.each_pair do |key, question|
        result << "config['#{key}'] ||= #{question.compile}"
      end
      result.join("\n")
    end

    class Prompt
      CONDITIONS = { 'if' => lambda {|value| "config['#{value}']"},
                     'if_scroll' => lambda{|value| "scroll?('#{value}')"},
                     'unless' => lambda{|value| "!config['#{value}']"},
                     'unless_scroll' => lambda{|value| "!scroll?('#{value}')"}
      }
      attr_reader :prompt, :details
      def initialize(details)
        @details = details
        @prompt = details['prompt']
      end

      def compile
        "#{question} if #{conditions}"
      end

      def question
        "ask_wizard(#{prompt.inspect})"
      end

      def conditions
        details.keys.map do |key|
          CONDITIONS[key].call(details[key]) if CONDITIONS[key]
        end.compact.push("true").join(" && ")
      end
    end

    class TrueFalse < Prompt
      def question
        "yes_wizard?(#{prompt.inspect})"
      end
    end

    class MultipleChoice < Prompt
      def question
        "multiple_choice(#{prompt.inspect}, #{@details['choices'].inspect})"
      end
    end

    QUESTION_TYPES = {
      'boolean' => TrueFalse,
      'string' => Prompt,
      'multiple_choice' => MultipleChoice
    }
  end
end
