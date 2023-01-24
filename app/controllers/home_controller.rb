class HomeController < ApplicationController
  def home
    csv_data = Csv::ParserService.call(path: "#{Rails.root}/public/movies.csv")
    p csv_data.raw_data

    service = Chartkick::HelperService.new(csv_data: csv_data)

    @types = %i[year_of_release run_time imdb_rating gross_total]
    @types.each do |type|
      instance_variable_set "@#{type}", service[type]
    end

    render 'home/home'
  end
end
