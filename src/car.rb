require 'nokogiri'
require 'open-uri'


##
# Klasa reprezentuje pojedyńczą instancje samochodu, pobraną z podstrony danego samochodu sprzedawanego na OTOMOTO
class Car
  attr_reader :url, :model, :data, :price

  ##
  # Na podstawie otrzymanego adresu URL podstrony samochodu,
  # np: https://www.otomoto.pl/oferta/volkswagen-tiguan-life-2-0-tdi-150-km-od-reki-plichta-gdansk-ID6EJroo.html,
  # pobierana jest strona HTML i zapisywana w @page. Pobierane z tej strony są następujące dane:
  # @model : String - nazwa modelu samochodu
  # @data : Hash - zbiera wszystkie dane zawarte w części szczegóły na podstronie otomoto
  # @price : String - zawiera cenę samochodu
  def initialize(car_page)
    @url = car_page
    @page = Nokogiri::HTML(URI.open(@url))
    @model = self.fetch_car_model
    @data = Hash.new
    @price = self.fetch_car_price
    self.fetch_car_data
  end

  ##
  # prywatna metoda zwracająca nazwę modelu samochodu
  def fetch_car_model
    @page.css(".offer-title").first.text.gsub(@page.css(".tags").first.text.strip, "").strip
  end

  ##
  # prywatna metoda zwracająca cenę samochodu
  def fetch_car_price
    @page.css(".offer-price__number").first.text.gsub(/\s+/, "")
  end

  ##
  # prywatna metoda dodająca do @data pokolei dane ze szczegółów w postaci hashmapy
  def fetch_car_data
    @page.css("li.offer-params__item").each do |item|
        @data.store(item.css(".offer-params__label").text.strip, item.css(".offer-params__value").text.strip)
    end
  end

  ##
  # metoda zwracająca adres URL zdjęcia samochodu
  def fetch_car_image
    @page.xpath("//div[@class='photo-item']/img/@data-lazy").first
  end

  private :fetch_car_data, :fetch_car_model, :fetch_car_price

end
