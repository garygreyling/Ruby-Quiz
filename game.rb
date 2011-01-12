module Madlib
  class Game
    def get_sentance
      puts 'Enter your madlib sentance:'
      @sentance = gets
      snor = Snor::Reader.new(@sentance)
      @variables_needed = snor.variables
    end

    def ask_for_inputs
      @variables_supplied = {}
      @variables_needed.each do |key, explanation|
        puts "Enter a #{key || explanation}:"
        @variables_supplied[key] = gets.chomp
      end
    end

    def display_madlib
      snor = Snor::Writer.new(@sentance, @variables_supplied)
      puts snor.result
    end
  end
end


module Snor
  PATTERN = /\(\([\w \:]*\)\)/

  class Reader
    attr_accessor :raw_text, :variables
    def initialize(text)
      @raw_text = text
      @variables = {}
      @raw_text.gsub(PATTERN).each do |match|
        match.extend(MatchedString)
        @variables[match.key] ||= match.explanation
      end
    end
  end

  class Writer
    attr_accessor :raw_text, :variables
    def initialize(raw_text, variables)
      @raw_text, @variables = raw_text, variables
    end

    def result
      @text ||= @raw_text.gsub(PATTERN).each do |match|
        match.extend(MatchedString)
        @variables[match.key]
      end
    end
  end

  module MatchedString
    def self.extended(obj)
      obj.delete!('(')
      obj.delete!(')')
    end

    def key
      split(':').first.downcase.gsub(' ', '_')
    end

    def explanation
      split(':')[1]
    end
  end
end