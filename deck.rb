require 'squib'
require 'pry'

BLOCK = 37.5
COLORS = {
  'R' => 'red',
  'Y' => 'yellow',
  'G' => 'green',
  'B' => 'blue',
  'N' => 'brown'
}

# Resource-producing allies
Squib::Deck.new width: 825, height: 1125, cards: 15, layout: 'layout.yml' do
  background color: '#ecc9a3'
  rect layout: 'cut'
  rect layout: 'bleed'
  data = xlsx file: 'data/allies/resource_allies.xlsx', explode: 'Quantity'

  svg file: 'icons/ally.svg', layout: 'icon'

  costs = data["Cost"].map {|str| str.split('').each_slice(2) }
  costs.each_with_index do |card_cost, card_number|
    card_cost.each_with_index do |(number, color), index|
      png range: card_number,
          file: "icons/cubes/#{color}.png",
          layout: 'cube',
          x: 8 * BLOCK + 3.5 * BLOCK * index,
          y: 4 * BLOCK
      text range: card_number,
           str: number,
           x: 9 * BLOCK  + 3.5 * BLOCK * index,
           y: 4.5 * BLOCK 
    end
  end

  rect layout: 'title'
  text str: data["Name"], layout: 'title'

  rect layout: 'art'
  text str: 'Art', layout: 'art', y: 13 * BLOCK

  rect layout: 'effect'
  png file: data["Color"].map {|c| "icons/cubes/#{c}_full.png"}, layout: 'cube', x: 10 * BLOCK, y: 19 * BLOCK
  
  rect layout: 'alt'
  text str: 'Trash this card for', layout: 'alt_text'
  svg file: 'icons/shield.svg', layout: 'alt_shield'
  text str: 1, layout: 'alt_points'
  save_png prefix: 'allies_'
end
