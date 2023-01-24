module Data
  class CalculatorService < ApplicationService
    def initialize(data:, type: :integer)
      @data = data
    end

    def call
      prepare_data
    end

    private

    attr_reader :data

    def prepare_data
      max = data.max
      min = data.min
      h = max - min
      # Step 3
      k = (1 + 3.32 * Math.log(data.count, 10)).round
      # Step 4
      interval_length = h / k.to_f
      interval_length = interval_length > 1 ? interval_length.ceil : interval_length.round(3)

      # Step 5 and 6
      intervals = []

      k.times do |i|
        intervals.push(Interval.new(min + i * interval_length, min + (i + 1) * interval_length))
      end

      # Step 7
      data.each do |value|
        intervals.each do |i|
          i.values_frequency += 1 if value >= i.min_value && value < i.max_value
        end
      end

      # Steps 8 and 9
      intervals.each do |i|
        i.relative_frequency = i.values_frequency.to_f / data.count
        i.density_of_relative_frequency = (i.relative_frequency / k).round(3)
      end

      Result.new(min, max, k, interval_length, intervals)
    end
  end

  class Interval
    attr_reader :min_value, :max_value, :middle_value
    attr_accessor :values_frequency, :relative_frequency, :density_of_relative_frequency

    def initialize(min_value, max_value)
      @min_value = min_value
      @max_value = max_value
      @middle_value = (max_value + min_value) / 2
      @values_frequency = 0
      @relative_frequency = 0
      @density_of_relative_frequency = 0
    end

    def to_s
      "[#{min_value}, #{max_value})"
    end
  end

  class Result
    attr_reader :min_value, :max_value, :k, :interval_length, :intervals

    def initialize(min_value, max_value, k, interval_length, intervals)
      @min_value = min_value
      @max_value = max_value
      @k = k
      @interval_length = interval_length
      @intervals = intervals
    end
  end
end
