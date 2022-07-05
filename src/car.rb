require 'nokogiri'
require 'open-uri'

class Car
  attr_reader :url, :model, :data, :price

  def initialize(car_page)
    @url = car_page
    @page = Nokogiri::HTML(URI.open(@url))
    @model = self.fetch_car_model
    @data = Hash.new
    @price = self.fetch_car_price
    self.fetch_car_data
  end

  def fetch_car_model
    @page.css(".offer-title").first.text.gsub(@page.css(".tags").first.text.strip, "").strip
  end


  def fetch_car_price
    @page.css(".offer-price__number").first.text.gsub(/\s+/, "")
  end

  def fetch_car_data
    @page.css("li.offer-params__item").each do |item|
        @data.store(item.css(".offer-params__label").text.strip, item.css(".offer-params__value").text.strip)
    end
  end

end
