require 'nokogiri'
require 'open-uri'

class Car
  attr_reader :url, :model, :data, :price

  def initialize(car_page)
    @url = car_page
    @page = Nokogiri::HTML(URI.open(@url))
    @model = self.get_car_model
    @data = Hash.new
    @price = self.get_car_price
    self.get_car_data
  end

  def get_car_model
    @page.css(".offer-title").first.text.gsub(@page.css(".tags").first.text.strip, "").strip
  end


  def get_car_price
    @page.css(".offer-price__number").first.text.gsub(/\s+/, "")
  end

  def get_car_data
    @page.css("li.offer-params__item").each do |item|
        @data.store(item.css(".offer-params__label").text.strip, item.css(".offer-params__value").text.strip)
    end
    puts "Fetched car data"
  end

end
