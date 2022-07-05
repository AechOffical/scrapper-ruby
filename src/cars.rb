require 'nokogiri'
require 'open-uri'

class Cars
  def initialize(car_company, number_of_pages)
    @url = "https://www.otomoto.pl/osobowe/" + car_company
    @cars = Array.new
    @cars_urls = Array.new
    @number_of_pages = number_of_pages
    self.fetch_cars
  end

  def fetch_cars
    i = 1
    while i <= @number_of_pages do
      doc = Nokogiri::HTML(URI.open(@url + "?page=" + i.to_s))
      doc.xpath("//h2[@data-testid='ad-title']/a/@href").each do |item|
        @cars << Car.new(item)
      end
      i += 1
    end
  end

  def read_cars(data_indexes, separator = "," , header = true)
    result = ""
    if header
      result += "Model Name" + separator
      result += "Price" + separator
      data_indexes.each do |index|
        result += index + separator
      end
      result += "URL;\n"
    end

    @cars.each do |item|

      row = item.model + separator
      row += item.price + separator

      data_indexes.each do |index|

        begin
        row += item.data.fetch(index) + separator
        rescue  IndexError
          puts item.model + " nie ma takiego atrybutu: " + index
        end

      end

      row += item.url.value + separator
      row += "\n"
      result += row
      sleep 0.2
    end
    result
  end
end
