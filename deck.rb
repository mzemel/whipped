require 'squib'
require 'pry'

Squib::Deck.new width: 825, height: 1125, cards: 15 do
  data = xlsx file: 'data/allies/resource_allies.xlsx'

  png file: 'icons/ally.png'
  text str: data["Name"], x: inches(1), y: inches(1)

  #tldr this reads every row and says "these are the cubes in slot 1, these are the cubes in slot 2...
  #  and has 5 slots for cubes.  Most are nil, so an empty image prints there
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
  cost_colors.each do |index, value|
    png file: value, x: inches(1) + inches(index)/2
    text str: cost_counts[index], x: inches(1.1) + inches(index)/2, y: inches(0.1)
  end
  png file: data["Color"].map {|c| "icons/cubes/#{c}.png"}, x: inches(1), y: inches(2)
  
  # rider
  # png file: data["Rider Cost"].map {|c| "icons/cubes/#{c}.png"}, x: inches(1), y: inches(3)
  save_png prefix: 'allies_'
end
