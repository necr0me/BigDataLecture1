module Chartkick
  class HelperService
    attr_reader :csv_data

    def initialize(csv_data: )
      @csv_data = csv_data
    end

    def [](type)
      data = Data::CalculatorService.call(data: csv_data[type])
      prepare(data, type)
    end

    def prepare(result, type)
      hash = Hash.new(0)
      result.intervals.each do |interval|
        hash[get_key(interval, type.to_s)] += interval.density_of_relative_frequency
      end
      View.new(
        type,
        result.min_value,
        result.max_value,
        result.k,
        result.intervals,
        result.interval_length,
        hash
      )
    end

    def get_key(interval, type)
      case type
      when 'year_of_release'
        "from #{interval.min_value} to #{interval.max_value - 1}"
      when 'run_time'
        "from #{interval.min_value} to #{interval.max_value - 1}"
      when 'imdb_rating'
        "from #{interval.min_value} to #{interval.max_value}"
      when 'gross_total'
        "from $#{interval.min_value}M to $#{interval.max_value - 1}M"
      else
        raise 'InvalidKey'
      end
    end
  end

  class View
    attr_reader :name, :min_value, :max_value, :k, :intervals, :interval_length, :hash

    def initialize(name, min_value, max_value, k, intervals, interval_length, hash)
      @name = name
      @min_value = min_value
      @max_value = max_value
      @k = k
      @intervals = intervals
      @interval_length = interval_length
      @hash = hash
    end
  end
end