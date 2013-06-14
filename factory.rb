#!/usr/bin/env ruby
# Chapter 13
class HabitatFactory
  
  # This an abstract factory that leave creation of organisms to another factory
  def initialize(num_animals, num_plants, organism_factory)
    @organism_factory = organism_factory
    @animals = []
    num_animals.times do |i|
      @animals << @organism_factory.new_organism(:animal, i)
    end
  
    @plants = []
    num_plants.times do |i|
      @plants << @organism_factory.new_organism(:plant, i)
    end
  end
  
  def simulate_one_day
    @plants.shuffle.each {|p| plant.grow }
    @animals.shuffle.each {|a| animal.speak }
    @animals.shuffle.each {|a| animal.eat }
    @animals.shuffle.each {|a| animal.sleep }
  end
   
  # def new_organism(type, id)  
  #   if type == :animal
  #     @animal_class.new("Animal#{id}")
  #   elsif type == :plant
  #     @plant_class.new("Plant#{id}")
  #   else
  #     raise "Unknown organism"
  #   end
  # end
  
end

# Abstract Factory Interface
# * new_animal
# * new_plant
class OrganismFactory
  
  def initialize(plant_class, animal_class)
    @plant_class = plant_class
    @animal_class = animal_class
  end
  
  def new_animal(name)
    @animal_class.new(name)
  end
  
  def new_plant(name)
    @plant_class.new(name)
  end
  
end

pond = HabitatFactory.new(3, 2, PondOrganismFactory.new(WaterLily, Frog))
pond.simulate_one_day

jungle = HabitatFactory.new(3, 4, JungleOrganismFactory.new(Tree, Tiger))
jungle.simulate_one_day
