require_relative "car"
require_relative 'cars'
require "open-uri"


require "open-uri"

# File.open('pie.png', 'wb') do |fo|
#   fo.write URI.open("https://ireland.apollo.olxcdn.com/v1/files/eyJmbiI6Ijd4bHZzdXBwbXF5ODMtT1RPTU9UT1BMIiwidyI6W3siZm4iOiJ3ZzRnbnFwNnkxZi1PVE9NT1RPUEwiLCJzIjoiMTYiLCJwIjoiMTAsLTEwIiwiYSI6IjAifV19.9V7rpk2PYWJCKfmYKpqn57eGMiCskYGxf1sF5uyJFcQ/image;s=1080x720").read
# end


cars = Cars.new("volkswagen", 3)
cars.read_cars_pdf ["Rok produkcji", "Pojemność skokowa"]

# car = Car.new("https://www.otomoto.pl/oferta/volkswagen-tiguan-life-2-0-tdi-150-km-od-reki-plichta-gdansk-ID6EJroo.html")
# car.fetch_car_image

