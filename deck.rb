require 'squib'
require 'pry'

Squib::Deck.new width: 825, height: 1125, cards: 15 do
  data = xlsx file: 'data/allies/resource_allies.xlsx'

  png file: 'icons/ally.png'
  text str: data["Name"], x: inches(1), y: inches(1)
  cost_colors = {}
  cost_counts = {}
  data["Cost"].each_with_index do |row, row_index|
    row.split('').each_slice(2).with_index do |(count, color), index| # '1R2Y' => [['1','R'], ['2','Y']]
      cost_colors[index] ||= Array.new(15)
      cost_counts[index] ||= Array.new(15)
      cost_colors[index][row_index] = "icons/cubes/#{color}.png"
      cost_counts[index][row_index] = count
    end
  end
  (0..4).each do |i| # hack; prints a cube PNG 5 times; if data is missing, print an empty PNG
                     # this will need to be refactored if we need a lotta cubes, or if we want to add "OR" slash mark
    # png file: data["Cost"].map {|cell| cell.split("").map {|c| "icons/cubes/#{c}.png"}[i]}, x: inches(1) + inches(i)/2
    png file: cost_colors[i], x: inches(1) + inches(i)/2
  end
  png file: data["Color"].map {|c| "icons/cubes/#{c}.png"}, x: inches(1), y: inches(2)
  
  # rider
  # png file: data["Rider Cost"].map {|c| "icons/cubes/#{c}.png"}, x: inches(1), y: inches(3)
  save_png prefix: 'allies_'
end
