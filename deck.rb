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

def draw_grid!
  30.times {|i| line x1: 0.blocks, x2: 22.blocks, y1: i.blocks, y2: i.blocks, dash: '3 3'}
  22.times {|i| line x1: i.blocks, x2: i.blocks, y1: 0.blocks, y2: 30.blocks, dash: '3 3'}
end

COLORS = {
  'bill_background' => '#d5d1cc',
  'bill_veto' => '#9d9a96',
  'event_background' => '#fffde4',
  'ally_background' => '#fee6ce',
}

Squib::Deck.new width: 825, height: 1125, cards: 5, layout: 'layout.yml' do
  data = xlsx file: 'data/players.xlsx', explode: 'Quantity'
  rect layout: 'cut'
  rect layout: 'bleed', fill_color: data['Background_Color'].map {|c| "##{c}"}

  rect layout: 'art', y: 3.blocks, stroke_width: 0

  #first income column
  5.times do |i|
    fill_colors = data['Hex'].zip(data['Min_Money']).zip(data['Money']).map do |(color, min_money), money|
      if min_money.to_i < i + 1 && money.to_i >= i + 1
        'gray'
      elsif min_money.to_i >= i + 1
        "##{color}"
      else
        'white'
      end
    end
    rect x: 3.blocks, y: (20 - i*2.5).blocks, height: 2.5.blocks, width: 2.5.blocks, fill_color: fill_colors
  end

  #  second income column
  5.times do |i|
    fill_colors = data['Hex'].zip(data['Min_Money']).zip(data['Money']).map do |(color, min_money), money|
      if min_money.to_i < i + 6 && money.to_i >= i + 6
        'gray'
      elsif min_money.to_i >= i + 6
        "##{color}"
      else
        'white'
      end
    end
    rect x: 5.5.blocks, y: (20 - i*2.5).blocks, height: 2.5.blocks, width: 2.5.blocks, fill_color: fill_colors
  end
  
  #peek
  peek_players = data['Color'].map.with_index {|p, i| i if p != 'green'}.compact
  5.times do |i|
    fill_colors = data['Hex'].zip(data['Min_Peek']).zip(data['Peek']).map do |(color, min_peek), peek|
      if min_peek.to_i < i + 1 && peek.to_i >= i + 1
        'gray'
      elsif min_peek.to_i >= i + 1
        "##{color}"
      else
        'white'
      end
    end
    rect range: peek_players, x: 11.blocks, y: (20 - i*2.5).blocks, height: 2.5.blocks, width: 2.5.blocks, fill_color: fill_colors
  end

  #trade
  trade_players = data['Color'].map.with_index {|p, i| i if p != 'red'}.compact
  5.times do |i|
    fill_colors = data['Hex'].zip(data['Min_Trade']).zip(data['Trade']).map do |(color, min_trade), trade|
      if min_trade.to_i < i + 1 && trade.to_i >= i + 1
        'gray'
      elsif min_trade.to_i >= i + 1
        "##{color}"
      else
        'white'
      end
    end
    rect range: trade_players, x: 16.5.blocks, y: (20 - i*2.5).blocks, height: 2.5.blocks, width: 2.5.blocks, fill_color: fill_colors
  end

  png file: 'icons/money.png', layout: 'icon_small', x: 3.blocks, y: 22.75.blocks
  png file: 'icons/ally_number.png', layout: 'icon_small', x: 8.75.blocks, y: 22.75.blocks
  png file: 'icons/trade.png', layout: 'icon_small', x: 14.75.blocks, y: 22.75.blocks

  save_pdf file: 'players.pdf', prefix: 'players_'
  save_png prefix: 'players_'
end


# allies
Squib::Deck.new width: 825, height: 1125, cards: 41, layout: 'layout.yml' do
  rect layout: 'cut'
  rect layout: 'bleed', fill_color: COLORS['ally_background']
  data = xlsx file: 'data/allies.xlsx', explode: 'Quantity'

  png file: 'icons/ally.png', layout: 'icon'

  costs = data["Cost"].map {|str| str.split('').each_slice(2) }
  costs.each_with_index do |card_cost, card_number|
    card_cost.each_with_index do |(number, color), index|
      png range: card_number,
        file: "icons/cubes/#{color}.png",
        layout: 'cube_large',
        x: 8.75.blocks + 6.blocks * index,
        y: 3.blocks
      text range: card_number,
        layout: 'cube_cost_large',
         str: number,
         x: 8.75.blocks  + 6.blocks * index,
         y: 3.75.blocks 
    end
  end

  first_divider_range = costs.map.with_index {|c, i| i if c.size > 1 }.compact
  line range: first_divider_range, x1: 13.75.blocks, y1: 7.5.blocks, x2: 14.75.blocks, y2: 3.5.blocks, stroke_width: 10

  # rect layout: 'title'
  text str: data["Name"], layout: 'title', y: 9.5.blocks

  rect layout: 'art'
  # text str: 'Art', layout: 'art', y: 13.blocks

  text str: data['Text'], layout: 'title', y: 17.5.blocks

  types = {}; data['Type'].each_with_index{ |t, i| (types[t] ||= []) << i}
  plus_sign_range = data['Sign'].each_with_index.map {|v,i| i if v == "+"}.compact
  plus_sign_range_2 = data['Sign_2'].each_with_index.map {|v,i| i if v == "+"}.compact
  types.each do |type, collection|
    case type
    when 'Single_Resource'
      png range: collection, file: data["Color"].map {|c| c = 'empty' if c.to_s.size != 1; "icons/cubes/#{c}_full.png"}, layout: 'cube_large', x: 8.75.blocks, y: 18.blocks
      rect range: collection, layout: 'ally_alt'
      text range: collection, str: 'Trash from hand:', layout: 'ally_alt_text'
      png range: collection, file: "icons/cubes/X.png", layout: 'cube', x: 15.blocks, y: 24.blocks
      text range: collection, str: 3, layout: 'cube_cost', x: 15.blocks, y: 24.5.blocks
    when 'Double_Resource'
      png range: collection, file: data['Color'].map {|colors| "icons/cubes/#{colors.split('').first}_full.png" if colors.to_s.size == 2}, layout: 'cube_large', x: 5.5.blocks, y: 18.blocks
      png range: collection, file: data['Color'].map {|colors| "icons/cubes/#{colors.split('').last}_full.png" if colors.to_s.size == 2}, layout: 'cube_large', x: 11.5.blocks, y: 18.blocks
      rect range: collection, layout: 'ally_alt'
      text range: collection, str: 'Trash from hand:', layout: 'ally_alt_text'
      png range: collection, file: 'icons/shield.png', layout: 'ally_alt_shield', x: 15.blocks, y: 24.blocks 
      text range: collection, str: 1, layout: 'ally_alt_points'
    when 'Bodyguard'
      png range: collection, file: 'icons/dagger.png', layout: 'icon', x: 5.blocks, y: 20.blocks
      line range: collection, x1: 10.blocks, y1: 24.5.blocks, x2: 11.5.blocks, y2: 20.5.blocks, stroke_width: 10
      png range: collection, file: 'icons/shield.png', layout: 'icon', x: 12.blocks, y: 20.blocks
      text range: collection, str: '-2', layout: 'icon', x: 12.blocks, y: 21.blocks, font_size: 24, align: 'center'
    when 'Single_Attribute'
      png range: collection, file: data['Icon'].map {|i| i ||= 'empty'; "icons/#{i}.png"}, layout: 'icon', x: 6.blocks, y: 20.blocks
      line range: collection, x1: 12.blocks, y1: 22.5.blocks, x2: 14.blocks, y2: 22.5.blocks, stroke_width: 10
      line range: collection & plus_sign_range, x1: 13.blocks, y1: 21.5.blocks, x2: 13.blocks, y2: 23.5.blocks, stroke_width: 10
      text range: collection, str: data['Number'], x: 14.blocks, y: 21.blocks, width: 3.blocks, height: 3.blocks, align: 'center', font_size: 24
    when 'Double_Attribute'
      png range: collection, file: data['Icon'].map {|i| i ||= 'empty'; "icons/#{i}.png"}, layout: 'icon', x: 6.blocks, y: 17.5.blocks
      line range: collection, x1: 12.blocks, y1: 20.blocks, x2: 14.blocks, y2: 20.blocks, stroke_width: 10
      line range: collection & plus_sign_range, x1: 13.blocks, y1: 19.blocks, x2: 13.blocks, y2: 21.blocks, stroke_width: 10
      text range: collection, str: data['Number'], x: 14.blocks, y: 18.5.blocks, width: 3.blocks, height: 3.blocks, align: 'center', font_size: 24

      # second icons
      png range: collection, file: data['Icon_2'].map {|i| i ||= 'empty'; "icons/#{i}.png"}, layout: 'icon', x: 6.blocks, y: 23.blocks
      line range: collection, x1: 12.blocks, y1: 25.5.blocks, x2: 14.blocks, y2: 25.5.blocks, stroke_width: 10
      line range: collection & plus_sign_range_2, x1: 13.blocks, y1: 24.5.blocks, x2: 13.blocks, y2: 26.5.blocks, stroke_width: 10
      text range: collection, str: data['Number_2'], x: 14.blocks, y: 24.blocks, width: 3.blocks, height: 3.blocks, align: 'center', font_size: 24
    end
  end
  
  # draw_grid!

  save_png prefix: 'allies_'
  # save_sheet sprue: 'a4_usa_card.yml', prefix: 'allies_resource_'
  save_pdf file: 'allies.pdf', prefix: 'allies_'
end

Squib::Deck.new width: 825, height: 1125, cards: 60, layout: 'layout.yml' do
  rect layout: 'cut'
  rect layout: 'bleed', fill_color: '#d5d1cc'
  data = xlsx file: 'data/bills.xlsx', explode: 'Quantity'

  png file: 'icons/scroll_white.png', layout: 'icon'
  rect x: 9.25.blocks, y: 2.blocks, width: 10.75.blocks, height: 6.25.blocks, stroke_width: 0, fill_color: COLORS['bill_veto']
  line x1: 10.25.blocks, y1: 4.25.blocks, x2: 12.25.blocks, y2: 6.25.blocks, stroke_width: 10, stroke_color: 'black'
  line x1: 10.25.blocks, y1: 6.25.blocks, x2: 12.25.blocks, y2: 4.25.blocks, stroke_width: 10, stroke_color: 'black'
  circle x: 13.25.blocks, y: 4.75.blocks, radius: 6, fill_color: 'black'
  circle x: 13.25.blocks, y: 5.75.blocks, radius: 6, fill_color: 'black'
  png file: data["Veto_Color"].map {|c| "icons/cubes/#{c}.png"}, layout: 'cube_large', x: 14.blocks, y: 2.75.blocks
  text str: data["Veto_Cost"], layout: 'cube_cost_large', x: 14.blocks, y: 3.5.blocks

  # text str: data["Name"], layout: 'title'

  # rect layout: 'art', height: 5.blocks
  # text str: 'Art', layout: 'art_text'

  png file: data['Color_1'].map {|c| "icons/cubes/#{c}.png"}, layout: 'cube_large', x: 3.blocks, y: 9.5.blocks
  text str: data['Cost_1'], layout: 'cube_cost_large', x: 3.blocks, y: 10.25.blocks
  png file: 'icons/shield.png', layout: 'shield_large', x: 14.blocks, y: 9.5.blocks
  text str: data['Reward_1'], layout: 'shield_text_large', x: 14.blocks, y: 10.5.blocks
  line x1: 9.blocks, x2: 13.blocks, y1: 12.blocks, y2: 12.blocks, stroke_width: 10
  triangle x1: 12.5.blocks, y1: 11.5.blocks, x2: 12.5.blocks, y2: 12.5.blocks, x3: 13.5.blocks, y3: 12.blocks, fill_color: 'black'

  png file: data['Color_2'].map {|c| "icons/cubes/#{c}.png"}, layout: 'cube_large', x: 3.blocks, y: 16.blocks
  text str: data['Cost_2'], layout: 'cube_cost_large', x: 3.blocks, y: 16.75.blocks
  png file: 'icons/shield.png', layout: 'shield_large', x: 14.blocks, y: 16.blocks
  text str: data['Reward_2'], layout: 'shield_text_large', x: 14.blocks, y: 17.blocks
  line x1: 9.blocks, x2: 13.blocks, y1: 18.5.blocks, y2: 18.5.blocks, stroke_width: 10
  triangle x1: 12.5.blocks, y1: 18.blocks, x2: 12.5.blocks, y2: 19.blocks, x3: 13.5.blocks, y3: 18.5.blocks, fill_color: 'black'

  png file: data['Color_3'].map {|c| "icons/cubes/#{c}.png"}, layout: 'cube_large', x: 3.blocks, y: 22.5.blocks
  text str: data['Cost_3'], layout: 'cube_cost_large', x: 3.blocks, y: 23.25.blocks
  png file: 'icons/shield.png', layout: 'shield_large', x: 14.blocks, y: 22.5.blocks
  text str: data['Reward_3'], layout: 'shield_text_large', x: 14.blocks, y: 23.5.blocks
  line x1: 9.blocks, x2: 13.blocks, y1: 25.blocks, y2: 25.blocks, stroke_width: 10
  triangle x1: 12.5.blocks, y1: 24.5.blocks, x2: 12.5.blocks, y2: 25.5.blocks, x3: 13.5.blocks, y3: 25.blocks, fill_color: 'black'

  save_png prefix: 'bill_'
  save_pdf file: 'bills.pdf', prefix: 'bills_'
end

# events
Squib::Deck.new width: 825, height: 1125, cards: 66, layout: 'layout.yml' do
  rect layout: 'cut'
  rect layout: 'bleed', fill_color: COLORS['event_background']
  data = xlsx file: 'data/events.xlsx', explode: 'Quantity'

  png file: 'icons/event_white.png', layout: 'icon'
  
  costs = data["Cost"].map {|str| str.split('').each_slice(2) }
  costs.each_with_index do |card_cost, card_number|
    card_cost.each_with_index do |(number, color), index|
      png range: card_number,
        file: "icons/cubes/#{color}.png",
        layout: 'cube_large',
        x: 8.75.blocks + 6.blocks * index,
        y: 3.blocks
      text range: card_number,
        layout: 'cube_cost_large',
         str: number,
         x: 8.75.blocks  + 6.blocks * index,
         y: 3.75.blocks 
    end
  end

  first_divider_range = costs.map.with_index {|c, i| i if c.size > 1 }.compact
  line range: first_divider_range, x1: 13.75.blocks, y1: 7.5.blocks, x2: 14.75.blocks, y2: 3.5.blocks, stroke_width: 10

  # text str: data["Name"], layout: 'title'

  # rect layout: 'art', height: 5.blocks
  # text str: 'Art', layout: 'art_text'

  text str: data['Text'], layout: 'title', y: 10.blocks

  types = {}; data['Type'].each_with_index{ |t, i| (types[t] ||= []) << i}
  plus_sign_range = data['Votes_Sign'].each_with_index.map {|v,i| i if v == "+"}.compact
  plus_sign_range_2 = data['Votes_Sign_2'].each_with_index.map {|v,i| i if v == "+"}.compact
  types.each do |type, collection|
    case type
    when 'Votes'
      png range: collection, file: "icons/scroll_white.png", layout: 'icon', x: 5.blocks, y: 13.5.blocks
      line range: collection, x1: 10.5.blocks, y1: 15.5.blocks, x2: 12.5.blocks, y2: 15.5.blocks, stroke_width: 10
      line range: collection & plus_sign_range, x1: 11.5.blocks, y1: 14.5.blocks, x2: 11.5.blocks, y2: 16.5.blocks, stroke_width: 10
      png range: collection & plus_sign_range, file: data["Votes_Color"].map {|c| c ||= 'empty'; "icons/cubes/#{c}.png" }, layout: 'cube_large', x: 13.blocks, y: 13.5.blocks
      png range: collection - plus_sign_range, file: data["Votes_Color"].map {|c| c ||= 'empty'; "icons/cubes/#{c}_full.png" }, layout: 'cube_large', x: 13.blocks, y: 13.5.blocks
      text range: collection & plus_sign_range, str: data["Votes_Number"], layout: 'cube_cost_large', x: 13.blocks, y: 14.25.blocks
    when 'Research'
      png range: collection, file: 'icons/ally_number.png', layout: 'icon', x: 8.5.blocks, y: 13.5.blocks
    when 'Assassinate'
      png range: collection, file: 'icons/dagger.png', layout: 'icon', x: 8.5.blocks, y: 13.5.blocks
    when 'Attribute'
      png range: collection, file: data['Icon'].map {|i| i ||= 'empty'; "icons/#{i}.png"}, layout: 'icon', x: 6.blocks, y: 14.blocks
      line range: collection, x1: 12.blocks, y1: 16.5.blocks, x2: 14.blocks, y2: 16.5.blocks, stroke_width: 10
      line range: collection & plus_sign_range, x1: 13.blocks, y1: 15.5.blocks, x2: 13.blocks, y2: 17.5.blocks, stroke_width: 10
      text range: collection, str: "1", x: 14.blocks, y: 15.blocks, width: 3.blocks, height: 3.blocks, align: 'center', font_size: 24
    when 'Double_Attribute'
      png range: collection, file: data['Icon'].map {|i| i ||= 'empty'; "icons/#{i}.png"}, layout: 'icon', x: 6.blocks, y: 10.blocks
      line range: collection, x1: 12.blocks, y1: 12.5.blocks, x2: 14.blocks, y2: 12.5.blocks, stroke_width: 10
      line range: collection & plus_sign_range, x1: 13.blocks, y1: 11.5.blocks, x2: 13.blocks, y2: 13.5.blocks, stroke_width: 10
      text range: collection, str: "1", x: 14.blocks, y: 11.blocks, width: 3.blocks, height: 3.blocks, align: 'center', font_size: 24

      # second icons
      png range: collection, file: data['Icon_2'].map {|i| i ||= 'empty'; "icons/#{i}.png"}, layout: 'icon', x: 6.blocks, y: 16.blocks
      line range: collection, x1: 12.blocks, y1: 18.5.blocks, x2: 14.blocks, y2: 18.5.blocks, stroke_width: 10
      line range: collection & plus_sign_range_2, x1: 13.blocks, y1: 17.5.blocks, x2: 13.blocks, y2: 19.5.blocks, stroke_width: 10
      text range: collection, str: "1", x: 14.blocks, y: 17.blocks, width: 3.blocks, height: 3.blocks, align: 'center', font_size: 24
    when 'Intrigue'
      png range: collection, file: 'icons/steal.png', layout: 'icon', x: 4.5.blocks, y: 13.5.blocks
      png range: collection, file: 'icons/ally.png', layout: 'icon', x: 11.5.blocks, y: 13.5.blocks
    when 'Votes_All'
      png range: collection, file: "icons/scroll_white.png", layout: 'icon', x: 5.blocks, y: 13.5.blocks
      line range: collection, x1: 10.5.blocks, y1: 15.5.blocks, x2: 12.5.blocks, y2: 15.5.blocks, stroke_width: 10
      line range: collection, x1: 11.5.blocks, y1: 14.5.blocks, x2: 11.5.blocks, y2: 16.5.blocks, stroke_width: 10
      png range: collection, file: 'icons/cubes/X.png', layout: 'cube_large', x: 13.blocks, y: 13.5.blocks
      text range: collection, str: 3, layout: 'cube_cost_large', x: 13.blocks, y: 14.25.blocks
    end
  end

  reward_riders = data['Rider_Reward'].map.with_index {|r, i| i if r}.compact

  # Reward riders
  rect layout: 'rider', y: 21.75.blocks, fill_color: COLORS['bill_background'], height: 6.25.blocks
  png range: reward_riders, file: data["Rider_Color"].map { |c| "icons/cubes/#{c}.png" }, layout: 'cube_large', x: 3.blocks, y: 22.5.blocks
  text range: reward_riders, str: data["Rider_Cost"], layout: 'cube_cost_large', x: 3.blocks, y: 23.25.blocks
  png range: reward_riders, file: 'icons/shield.png', layout: 'shield_large', x: 14.blocks, y: 22.5.blocks
  text str: data["Rider_Reward"], layout: 'shield_text_large', x: 14.blocks, y: 23.25.blocks
  line range: reward_riders, x1: 9.blocks, x2: 13.blocks, y1: 25.blocks, y2: 25.blocks, stroke_width: 10
  triangle range: reward_riders, x1: 12.5.blocks, y1: 24.5.blocks, x2: 12.5.blocks, y2: 25.5.blocks, x3: 13.5.blocks, y3: 25.blocks, fill_color: 'black'

  # Veto riders
  veto_riders = data['Rider_Reward'].map.with_index {|r, i| i if !r}.compact
  rect layout: 'rider', range: veto_riders, y: 21.75.blocks, fill_color: COLORS['bill_veto'], height: 6.25.blocks
  line range: veto_riders, x1: 10.25.blocks, y1: 24.blocks, x2: 12.25.blocks, y2: 26.blocks, stroke_width: 10, stroke_color: 'black'
  line range: veto_riders, x1: 10.25.blocks, y1: 26.blocks, x2: 12.25.blocks, y2: 24.blocks, stroke_width: 10, stroke_color: 'black'
  circle range: veto_riders, x: 13.25.blocks, y: 24.5.blocks, radius: 6, fill_color: 'black'
  circle range: veto_riders, x: 13.25.blocks, y: 25.5.blocks, radius: 6, fill_color: 'black'
  png range: veto_riders, file: data["Rider_Color"].map { |c| c ||= 'empty'; "icons/cubes/#{c}.png" }, layout: 'cube_large', x: 14.blocks, y: 22.25.blocks
  text range: veto_riders, str: data["Rider_Cost"], layout: 'cube_cost_large', x: 14.blocks, y: 23.blocks

  # draw_grid!


  save_pdf file: 'events.pdf', prefix: 'events_'
  save_png prefix: 'event_'
end
