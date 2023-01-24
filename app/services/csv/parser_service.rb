require 'csv'

module Csv
  class ParserService < ApplicationService
    def initialize(path: )
      @csv = CSV.new(File.open(path))
      @parsed_data = []
    end

    def call
      read_csv
    end

    def [](key)
      key = key.to_s
      case key
      when 'year_of_release'
        parsed_data.map { |el| el[key].tr('()', '').to_i }
      when 'run_time'
        parsed_data.map { |el| el[key].split(' min').first.to_i }
      when 'imdb_rating'
        parsed_data.map { |el| el[key].to_f }
      when 'gross_total'
        parsed_data.map { |el| el[key]&.tr('$M', '').to_f }
      else
        raise 'InvalidKey'
      end
    end

    def raw_data
      @raw_data
    end

    private

    attr_reader :csv, :parsed_data

    def read_csv
      @raw_data = csv.read
      @raw_data.drop(1).each do |line|
        hash = Hash.new
        @raw_data.first.each_with_index do |attribute, index|
          hash[attribute] = line[index]
        end
        parsed_data.push(hash)
      end
      self
    end
  end
end
