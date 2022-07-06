require 'nokogiri'
require 'open-uri'
require "prawn"

##
# Klasa Cars jest zbiorem obiektów typu Car
class Cars
  ##
  # Tworzy URL na podstawie nazwy samochodu następnie incjuje metody iterujące po stronach i zbierające dane na temat aut
  def initialize(car_company, number_of_pages)
    @car_company = car_company
    @url = "https://www.otomoto.pl/osobowe/" + @car_company
    @cars = Array.new
    @cars_urls = Array.new
    @number_of_pages = number_of_pages
    self.fetch_cars
  end


  ##
  # Zwraca dane na temat aut w formie pliku csv
  # argumenty:
  # data_indexes - array zawierający indexy szczegółów na temat samochodu
  # separator - separator, którym mają być oddzielone dane
  # header - czy ma zawierać wiersz nagłówkowy
  def read_cars(data_indexes, separator = ",", header = true)
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

  ##
  # robi to samo co read_cars, z różnicą taką, że dane od razu są zapisywane do result.pdf i wyświetlane są w wierszach
  # jedynym argumentem jest data_indexes czyli array zawierający nazwy szczegółów na temat samochodu
  def read_cars_pdf(data_indexes)
    pdf = Prawn::Document.new
    pdf.font_size 18
    pdf.text  "Dane z platformy OTOMOTO na temat aut marki " + @car_company

    pdf.font_size 10
    @cars.each do |item|
      pdf.pad(15) { pdf.stroke_horizontal_rule }
      pdf.text ""
      pdf.text "Nazwa modelu: " + item.model
      pdf.text "Cena: " + item.price

      data_indexes.each do |index|
        begin
          pdf.text index + " " + item.data.fetch(index)
        rescue  IndexError
          puts item.model + " nie ma  atrybutu: " + index
        rescue Prawn::Errors::IncompatibleStringEncoding
          pdf.text "Pojemnosc skokowa" + item.data.fetch(index)
        end

      end
      pdf.text "Link do strony auta: " + @url

    end
    pdf.render_file 'result.pdf'
  end



  private
  ##
  #prywatna metoda pobierająca URL do podstron samocodów, a następnie tworzy nowe obiekty samochodów i dodaje je do hashmapy @cars
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


end
