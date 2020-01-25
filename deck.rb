require 'squib'
require 'pry'

Squib::Deck.new width: 825, height: 1125, cards: 15 do
  data = xlsx file: 'data/allies/resource_allies.xlsx'

  png file: 'icons/ally.png'
  text str: data["Name"], x: inches(1), y: inches(1)

  costs = data["Cost"].map {|str| str.split('').each_slice(2) }
  costs.each_with_index do |card_cost, card_number|
    card_cost.each_with_index do |(number, color), index|
      png range: card_number, file: "icons/cubes/#{color}.png", x: inches(1) + inches(index)/2 
      text range: card_number, str: number, x: inches(1.1) + inches(index)/2, y: inches(0.1)
    end
  end

  png file: data["Color"].map {|c| "icons/cubes/#{c}.png"}, x: inches(1), y: inches(2)
  
  # rider
  # png file: data["Rider Cost"].map {|c| "icons/cubes/#{c}.png"}, x: inches(1), y: inches(3)
  save_png prefix: 'allies_'
end
