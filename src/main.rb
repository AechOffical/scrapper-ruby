require_relative "car"
require_relative 'cars'




cars = Cars.new("volkswagen", 3)
cars.read_cars_pdf ["Rok produkcji", "Pojemność skokowa"]


