require 'squib'
require 'pry'

class Integer
  def blocks
    self * 37.5
  end
end

class Float
  def blocks
    self * 37.5
  end
end

# Resource-producing allies
Squib::Deck.new width: 825, height: 1125, cards: 50, layout: 'layout.yml' do
  rect layout: 'cut'
  rect layout: 'bleed'
  data = xlsx file: 'data/allies.xlsx', explode: 'Quantity'

  svg file: 'icons/ally.svg', layout: 'icon'

  costs = data["Cost"].compact.map {|str| str.split('').each_slice(2) }
  costs.each_with_index do |card_cost, card_number|
    card_cost.each_with_index do |(number, color), index|
      png range: card_number,
          file: "icons/cubes/#{color}.png",
          layout: 'cube',
          x: 8.blocks + 4.blocks * index,
          y: 4.blocks
      text range: card_number,
           str: number,
           x: 9.blocks  + 4.blocks * index,
           y: 4.5.blocks 
    end
  end

  first_divider_range = costs.map.with_index {|c, i| i if c.size > 1 }.compact
  second_divider_range = costs.map.with_index {|c, i| i if c.size > 2 }.compact
  line range: first_divider_range, x1: 11.25.blocks, y1: 6.5.blocks, x2: 11.75.blocks, y2: 4.5.blocks, stroke_width: 10
  line range: second_divider_range, x1: 15.25.blocks, y1: 6.5.blocks, x2: 15.75.blocks, y2: 4.5.blocks, stroke_width: 10

  # rect layout: 'title'
  text str: data["Name"], layout: 'title'

  rect layout: 'art'
  text str: 'Art', layout: 'art', y: 13.blocks

  text str: data['Text'], layout: 'title', y: 17.blocks

  types = {}; data['Type'].each_with_index{ |t, i| (types[t] ||= []) << i}
  types.each do |type, collection|
    case type
    when 'Single_Resource'
      png range: collection, file: data["Color"].map {|c| c = 'empty' if c.to_s.size != 1; "icons/cubes/#{c}_full.png"}, layout: 'cube', x: 10.blocks, y: 19.blocks
      rect range: collection, layout: 'ally_alt'
      text range: collection, str: 'Trash this card for', layout: 'ally_alt_text'
      svg range: collection, file: 'icons/shield.svg', layout: 'ally_alt_shield'
      text range: collection, str: 1, layout: 'ally_alt_points'
    when 'Double_Resource'
      png range: collection, file: data['Color'].map {|colors| "icons/cubes/#{colors.split('').first}_full.png" if colors.to_s.size == 2}, layout: 'cube', x: 7.blocks, y: 19.blocks
      png range: collection, file: data['Color'].map {|colors| "icons/cubes/#{colors.split('').last}_full.png" if colors.to_s.size == 2}, layout: 'cube', x: 11.blocks, y: 19.blocks
    when 'Bodyguard'
      svg range: collection, file: 'icons/dagger.svg', layout: 'icon', x: 5.blocks, y: 18.5.blocks
      line range: collection, x1: 10.blocks, y1: 23.blocks, x2: 11.5.blocks, y2: 19.blocks, stroke_width: 10
      svg range: collection, file: 'icons/shield.svg', layout: 'icon', x: 12.blocks, y: 18.5.blocks
      text range: collection, str: '-2', layout: 'icon', x: 12.blocks, y: 19.blocks, font_size: 24, align: 'center'
    end
  end

  save_png prefix: 'allies_'
  # save_sheet sprue: 'a4_usa_card.yml', prefix: 'allies_resource_'
  # save_pdf file: 'fart.pdf', prefix: 'allies_resource_'
end

Squib::Deck.new width: 825, height: 1125, cards: 1, layout: 'layout.yml' do
  rect layout: 'cut'
  rect layout: 'bleed'
  data = xlsx file: 'data/bills.xlsx', explode: 'Quantity'

  png file: 'icons/scroll.png', layout: 'icon'
  rect x: 9.blocks, y: 3.blocks, width: 10.blocks, height: 4.blocks, dash: '3 3'
  line x1: 10.blocks, y1: 4.blocks, x2: 12.blocks, y2: 6.blocks, stroke_width: 10, stroke_color: '#ff0000'
  line x1: 10.blocks, y1: 6.blocks, x2: 12.blocks, y2: 4.blocks, stroke_width: 10, stroke_color: '#ff0000'
  circle x: 13.blocks, y: 4.5.blocks, radius: 6, fill_color: 'black'
  circle x: 13.blocks, y: 5.5.blocks, radius: 6, fill_color: 'black'
  png file: data["Veto_Color"].map {|c| "icons/cubes/#{c}.png"}, x: 15.blocks, y: 3.5.blocks, width: 3.blocks, height: 3.blocks
  text str: data["Veto_Cost"], layout: 'cube_cost', x: 15.blocks, y: 4.blocks

  # rect layout: 'title'
  text str: data["Name"], layout: 'title'

  rect layout: 'art', height: 5.blocks
  text str: 'Art', layout: 'art_text'

  png file: data['Color_1'].map {|c| "icons/cubes/#{c}.png"}, layout: 'cube', x: 3.blocks, y: 17.blocks
  text str: data['Cost_1'], layout: 'cube_cost', x: 3.blocks, y: 17.5.blocks
  svg file: 'icons/shield.svg', layout: 'shield', y: 17.blocks
  text str: data['Reward_1'], layout: 'shield_text', y: 17.5.blocks
  line x1: 7.blocks, x2: 14.blocks, y1: 18.5.blocks, y2: 18.5.blocks, stroke_width: 10
  triangle x1: 13.5.blocks, y1: 18.blocks, x2: 13.5.blocks, y2: 19.blocks, x3: 14.5.blocks, y3: 18.5.blocks, fill_color: 'black'

  png file: data['Color_2'].map {|c| "icons/cubes/#{c}.png"}, layout: 'cube', x: 3.blocks, y: 21.blocks
  text str: data['Cost_2'], layout: 'cube_cost', x: 3.blocks, y: 21.5.blocks
  svg file: 'icons/shield.svg', layout: 'shield', y: 21.blocks
  text str: data['Reward_2'], layout: 'shield_text', y: 21.5.blocks
  line x1: 7.blocks, x2: 14.blocks, y1: 22.5.blocks, y2: 22.5.blocks, stroke_width: 10
  triangle x1: 13.5.blocks, y1: 22.blocks, x2: 13.5.blocks, y2: 23.blocks, x3: 14.5.blocks, y3: 22.5.blocks, fill_color: 'black'

  png file: data['Color_3'].map {|c| "icons/cubes/#{c}.png"}, layout: 'cube', x: 3.blocks, y: 25.blocks
  text str: data['Cost_3'], layout: 'cube_cost', x: 3.blocks, y: 25.5.blocks
  svg file: 'icons/shield.svg', layout: 'shield', y: 25.blocks
  text str: data['Reward_3'], layout: 'shield_text', y: 25.5.blocks
  line x1: 7.blocks, x2: 14.blocks, y1: 26.5.blocks, y2: 26.5.blocks, stroke_width: 10
  triangle x1: 13.5.blocks, y1: 26.blocks, x2: 13.5.blocks, y2: 27.blocks, x3: 14.5.blocks, y3: 26.5.blocks, fill_color: 'black'

  save_png prefix: 'bill_'
end

Squib::Deck.new width: 825, height: 1125, cards: 60, layout: 'layout.yml' do
  rect layout: 'cut'
  rect layout: 'bleed'
  data = xlsx file: 'data/events.xlsx', explode: 'Quantity'

  png file: 'icons/event.png', layout: 'icon'
  
  costs = data["Cost"].map {|str| str.split('').each_slice(2) }
  costs.each_with_index do |card_cost, card_number|
    card_cost.each_with_index do |(number, color), index|
      png range: card_number,
          file: "icons/cubes/#{color}.png",
          layout: 'cube',
          x: 8.blocks + 4.blocks * index,
          y: 4.blocks
      text range: card_number,
           str: number,
           x: 9.blocks  + 4.blocks * index,
           y: 4.5.blocks 
    end
  end

  first_divider_range = costs.map.with_index {|c, i| i if c.size > 1 }.compact
  second_divider_range = costs.map.with_index {|c, i| i if c.size > 2 }.compact
  line range: first_divider_range, x1: 11.25.blocks, y1: 6.5.blocks, x2: 11.75.blocks, y2: 4.5.blocks, stroke_width: 10
  line range: second_divider_range, x1: 15.25.blocks, y1: 6.5.blocks, x2: 15.75.blocks, y2: 4.5.blocks, stroke_width: 10

  text str: data["Name"], layout: 'title'

  rect layout: 'art', height: 5.blocks
  text str: 'Art', layout: 'art_text'

  text str: data['Text'], layout: 'title', y: 17.blocks

  types = {}; data['Type'].each_with_index{ |t, i| (types[t] ||= []) << i}
  plus_sign_range = data['Votes_Sign'].each_with_index.map {|v,i| i if v == "+"}.compact
  types.each do |type, collection|
    case type
    when 'Votes'
      png range: collection, file: "icons/scroll.png", layout: 'icon', x: 5.blocks, y: 18.blocks
      line range: collection, x1: 10.blocks, y1: 20.blocks, x2: 12.blocks, y2: 20.blocks, stroke_width: 10
      line range: collection & plus_sign_range, x1: 11.blocks, y1: 19.blocks, x2: 11.blocks, y2: 21.blocks, stroke_width: 10
      png range: collection, file: data["Votes_Color"].map {|c| c ||= 'empty'; "icons/cubes/#{c}.png" }, layout: 'cube', x: 13.blocks, y: 18.5.blocks
      text range: collection, str: data["Votes_Number"], layout: 'cube_cost', x: 13.blocks, y: 19.blocks
    when 'Research'
      svg range: collection, file: 'icons/eye.svg', layout: 'icon', x: 8.5.blocks, y: 18.5.blocks
    when 'Assassinate'
      svg range: collection, file: 'icons/dagger.svg', layout: 'icon', x: 8.5.blocks, y: 18.5.blocks
    when 'Attribute'
      svg range: collection, file: data['Icon'].map {|i| i ||= 'empty'; "icons/#{i}.svg"}, layout: 'icon', x: 6.blocks, y: 18.blocks
      line range: collection, x1: 11.5.blocks, y1: 20.5.blocks, x2: 13.5.blocks, y2: 20.5.blocks, stroke_width: 10
      line range: collection & plus_sign_range, x1: 12.5.blocks, y1: 19.5.blocks, x2: 12.5.blocks, y2: 21.5.blocks, stroke_width: 10
      text range: collection, str: "1", x: 13.5.blocks, y: 19.blocks, width: 3.blocks, height: 3.blocks, align: 'center', font_size: 24
    when 'Intrigue'
      svg range: collection, file: 'icons/steal.svg', layout: 'icon', x: 6.blocks, y: 18.5.blocks
      svg range: collection, file: 'icons/ally.svg', layout: 'icon', x: 13.blocks, y: 18.5.blocks
    when 'Votes_All'
      png range: collection, file: "icons/scroll.png", layout: 'icon', x: 5.blocks, y: 18.blocks
      line range: collection, x1: 10.blocks, y1: 20.blocks, x2: 12.blocks, y2: 20.blocks, stroke_width: 10
      line range: collection, x1: 11.blocks, y1: 19.blocks, x2: 11.blocks, y2: 21.blocks, stroke_width: 10
      png range: collection, file: 'icons/cubes/A.png', layout: 'cube', x: 13.blocks, y: 18.5.blocks
      text range: collection, str: 2, layout: 'cube_cost', x: 13.blocks, y: 19.blocks
    end
  end

  reward_riders = data['Rider_Reward'].map.with_index {|r, i| i if r}.compact

  # Reward riders
  rect layout: 'rider'
  png range: reward_riders, file: data["Rider_Color"].map { |c| "icons/cubes/#{c}.png" }, layout: 'cube', x: 3.blocks, y: 24.5.blocks
  text range: reward_riders, str: data["Rider_Cost"], layout: 'cube', x: 4.blocks, y: 25.blocks
  svg range: reward_riders, file: 'icons/shield.svg', layout: 'rider_shield'
  text str: data["Rider_Reward"], layout: 'rider_points'
  line range: reward_riders, x1: 7.blocks, x2: 15.blocks, y1: 26.blocks, y2: 26.blocks, stroke_width: 10
  triangle range: reward_riders, x1: 14.5.blocks, y1: 25.5.blocks, x2: 14.5.blocks, y2: 26.5.blocks, x3: 15.5.blocks, y3: 26.blocks, fill_color: 'black'

  # Veto riders
  veto_riders = data['Rider_Reward'].map.with_index {|r, i| i if !r}.compact
  line range: veto_riders, x1: 10.blocks, y1: 25.blocks, x2: 12.blocks, y2: 27.blocks, stroke_width: 10, stroke_color: '#ff0000'
  line range: veto_riders, x1: 10.blocks, y1: 27.blocks, x2: 12.blocks, y2: 25.blocks, stroke_width: 10, stroke_color: '#ff0000'
  circle range: veto_riders, x: 13.blocks, y: 25.5.blocks, radius: 6, fill_color: 'black'
  circle range: veto_riders, x: 13.blocks, y: 26.5.blocks, radius: 6, fill_color: 'black'
  png range: veto_riders, file: data["Rider_Color"].map { |c| c ||= 'empty'; "icons/cubes/#{c}.png" }, layout: 'cube', x: 15.blocks, y: 24.5.blocks
  text range: veto_riders, str: data["Rider_Cost"], layout: 'cube_cost', x: 15.blocks, y: 25.blocks



  save_png prefix: 'event_'
end
