require_relative "car"
require_relative 'cars'

cars = Cars.new("volkswagen", 3)
File.write("result.csv", cars.read_cars(["Rok produkcji", "Pojemność skokowa"]))