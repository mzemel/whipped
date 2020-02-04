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
  'bill_border' => 'black',
  'bill_background' => '#e1e1e1',
  'bill_veto' => '#9d9a96',
  'event_border' => 'black',
  'event_background' => '#fcd9d9',
  'ally_border' => 'black',
  'ally_background' => '#f0dfb4'
}

Squib::Deck.new width: 825, height: 1125, cards: 11, layout: 'layout.yml' do
  data = xlsx file: 'data/alt/bills.xlsx'
  rect layout: 'cut'
  rect layout: 'bleed'

  png file: 'icons/one.png', x: 9.blocks, y: 3.blocks, width: 4.blocks, height: 4.blocks

  data['First'].map.with_index do |n, i|
    n.to_i.times do |j|
      rect range: i, x: 3.blocks + 2.5.blocks * j + 5 * j, y: 7.5.blocks, width: 2.5.blocks, height: 2.5.blocks
    end
  end

  png file: 'icons/two.png', x: 9.blocks, y: 11.blocks, width: 4.blocks, height: 4.blocks

  data['Second Required'].map.with_index do |n, i|
    n.to_i.times do |j|
      rect range: i, x: 3.blocks + 2.5.blocks * j + 5 * j, y: 16.blocks, width: 2.5.blocks, height: 2.5.blocks, dash: '3 3'
    end
  end

  data['Second Reward'].map.with_index do |n, i|
    n.to_i.times do |j|
      rect range: i, x: 3.blocks + 2.5.blocks * j + 5 * j, y: 16.blocks, width: 2.5.blocks, height: 2.5.blocks
    end
  end

  show_three = data['Third Required'].map.with_index {|el, i| i if el.to_i.nonzero? }.compact

  png range: show_three, file: 'icons/three.png', x: 9.blocks, y: 19.5.blocks, width: 4.blocks, height: 4.blocks

  data['Third Required'].map.with_index do |n, i|
    n.to_i.times do |j|
      rect range: i, x: 3.blocks + 2.5.blocks * j + 5 * j, y: 24.5.blocks, width: 2.5.blocks, height: 2.5.blocks, dash: '3 3'
    end
  end

  data['Third Reward'].map.with_index do |n, i|
    n.to_i.times do |j|
      rect range: i, x: 3.blocks + 2.5.blocks * j + 5 * j, y: 24.5.blocks, width: 2.5.blocks, height: 2.5.blocks
    end
  end

  save_pdf file: 'alt/bills.pdf', prefix: 'alt/bills_'
end


Squib::Deck.new width: 825, height: 1125, cards: 5, layout: 'layout.yml' do
  rect layout: 'cut'
  rect layout: 'bleed', fill_color: 'gray'

  png file: 'icons/one_white.png', x: 5.blocks, y: 9.blocks, width: 12.blocks, height: 12.blocks

  save_pdf file: 'alt/tokens_one.pdf', prefix: 'alt/tokens_one_'
end

Squib::Deck.new width: 825, height: 1125, cards: 5, layout: 'layout.yml' do
  rect layout: 'cut'
  rect layout: 'bleed', fill_color: 'gray'

  png file: 'icons/two_white.png', x: 5.blocks, y: 9.blocks, width: 12.blocks, height: 12.blocks

  save_pdf file: 'alt/tokens_two.pdf', prefix: 'alt/tokens_two_'
end

Squib::Deck.new width: 825, height: 1125, cards: 5, layout: 'layout.yml' do
  rect layout: 'cut'
  rect layout: 'bleed', fill_color: 'gray'

  png file: 'icons/three_white.png', x: 5.blocks, y: 9.blocks, width: 12.blocks, height: 12.blocks

  save_pdf file: 'alt/tokens_three.pdf', prefix: 'alt/tokens_three_'
end

Squib::Deck.new width: 825, height: 1125, cards: 5, layout: 'layout.yml' do
  rect layout: 'cut'
  rect layout: 'bleed', fill_color: 'gray'

  png file: 'icons/one.png', x: 5.blocks, y: 9.blocks, width: 12.blocks, height: 12.blocks

  save_pdf file: 'alt/tokens_one_back.pdf', prefix: 'alt/tokens_one_back_'
end

Squib::Deck.new width: 825, height: 1125, cards: 5, layout: 'layout.yml' do
  rect layout: 'cut'
  rect layout: 'bleed', fill_color: 'gray'

  png file: 'icons/two.png', x: 5.blocks, y: 9.blocks, width: 12.blocks, height: 12.blocks

  save_pdf file: 'alt/tokens_two_back.pdf', prefix: 'alt/tokens_two_back_'
end

Squib::Deck.new width: 825, height: 1125, cards: 5, layout: 'layout.yml' do
  rect layout: 'cut'
  rect layout: 'bleed', fill_color: 'gray'

  png file: 'icons/three.png', x: 5.blocks, y: 9.blocks, width: 12.blocks, height: 12.blocks

  save_pdf file: 'alt/tokens_three_back.pdf', prefix: 'alt/tokens_three_back_'

end

Squib::Deck.new width: 825, height: 1125, cards: 50, layout: 'layout.yml' do
  data = xlsx file: 'data/alt/riders.xlsx', explode: 'Quantity'
  rect layout: 'cut'
  rect layout: 'bleed'

  text str: data['Text'], x: 3.blocks, y: 9.blocks, width: 16.blocks, font: 'Raleway 18'

  save_pdf file: 'alt/riders.pdf', prefix: 'alt/riders_'
end

Squib::Deck.new width: 1125, height: 825, cards: 5, layout: 'layout.yml' do
  data = xlsx file: 'data/players.xlsx', explode: 'Quantity'
  rect layout: 'cut', width: 28.blocks, height: 20.blocks
  rect layout: 'bleed', fill_color: data['Hex'].map {|c| "##{c}"}, x: 2.blocks, y: 2.blocks, width: 26.blocks, height: 18.blocks

  # icons
  png file: 'icons/money.png', layout: 'icon_small', x: 2.75.blocks, y: 16.25.blocks, width: 3.blocks, height: 3.blocks
  png file: 'icons/ally_number.png', layout: 'icon_small', x: 13.5.blocks, y: 16.25.blocks, width: 3.blocks, height: 3.blocks
  png file: 'icons/trade.png', layout: 'icon_small', x: 24.25.blocks, y: 16.25.blocks, width: 3.blocks, height: 3.blocks

  # income
  fill_colors = 5.times.collect { 5.times.collect { 'white' }}
  data['Money'].each_with_index {|m, i| fill_colors[i][m.to_i - 6] = 'gray'}
  (6..10).each do |i|
    rect x: 3.blocks, y: 13.blocks - 2.5.blocks * (i - 6), width: 2.5.blocks, height: 2.5.blocks, fill_color: fill_colors.map {|arr| arr[i-6]}
    text str: i, x: 3.blocks, y: 13.blocks - 2.5.blocks * (i - 6), width: 2.5.blocks, font_size: 18, align: 'center'
  end

  # number of allies
  fill_colors = 5.times.collect { 5.times.collect { 'white' }}
  show_square = data['Min Ally Number'].map { |n| n.to_i.upto(5).to_a }
  data['Ally Number'].each_with_index {|m, i| fill_colors[i][m.to_i - 1] = 'gray'}
  (1..5).each do |i|
    next unless show_square[i-1].include?(i)
    range = (0..4).map {|j| j if show_square[j].include?(i)}.compact
    rect range: range, x: 13.75.blocks, y: 13.blocks - 2.5.blocks * (i - 1), width: 2.5.blocks, height: 2.5.blocks, fill_color: fill_colors.map {|arr| arr[i-1]}
    text range: range, str: i, x: 13.75.blocks, y: 13.blocks - 2.5.blocks * (i - 1), width: 2.5.blocks, font_size: 18, align: 'center'
  end

  # trade
  fill_colors = 5.times.collect { 5.times.collect { 'white' }}
  show_square = data['Min Trade'].map { |n| n.to_i.upto(5).to_a }
  data['Trade'].each_with_index {|m, i| fill_colors[i][m.to_i - 1] = 'gray'}
  (1..5).each do |i|
    next unless show_square[i-1].include?(i)
    range = (0..4).map {|j| j if show_square[j].include?(i)}.compact
    rect range: range, x: 24.5.blocks, y: 13.blocks - 2.5.blocks * (i - 1), width: 2.5.blocks, height: 2.5.blocks, fill_color: fill_colors.map {|arr| arr[i-1]}
    text range: range, str: i, x: 24.5.blocks, y: 13.blocks - 2.5.blocks * (i - 1), width: 2.5.blocks, font_size: 18, align: 'center'
  end

  save_png prefix: 'players_', rotate: true
  save_pdf file: 'players.pdf', prefix: 'players_', rotate: true
end
# 
# # allies
# Squib::Deck.new width: 825, height: 1125, cards: 38, layout: 'layout.yml' do
#   rect layout: 'cut', fill_color: COLORS['ally_border']
#   rect layout: 'bleed', fill_color: COLORS['ally_background']
#   data = xlsx file: 'data/allies.xlsx', explode: 'Quantity'
# 
#   png file: 'icons/ally.png', layout: 'icon'
# 
#   costs = data["Cost"].map {|str| str.split('').each_slice(2) }
#   costs.each_with_index do |card_cost, card_number|
#     card_cost.each_with_index do |(number, color), index|
#       png range: card_number,
#         file: "icons/cubes/#{color}.png",
#         layout: 'cube_large',
#         x: 8.75.blocks + 6.blocks * index,
#         y: 3.blocks
#       text range: card_number,
#         layout: 'cube_cost_large',
#          str: number,
#          x: 8.75.blocks  + 6.blocks * index,
#          y: 3.75.blocks 
#     end
#   end
# 
#   first_divider_range = costs.map.with_index {|c, i| i if c.size > 1 }.compact
#   line range: first_divider_range, x1: 13.75.blocks, y1: 7.5.blocks, x2: 14.75.blocks, y2: 3.5.blocks, stroke_width: 10
# 
#   # rect layout: 'title'
#   text str: data["Name"], layout: 'title', y: 9.5.blocks, font: 'Raleway Bold'
# 
#   rect layout: 'art'
#   # text str: 'Art', layout: 'art', y: 13.blocks
# 
#   text str: data['Text'], layout: 'title', y: 17.5.blocks, font: 'Raleway'
# 
#   types = {}; data['Type'].each_with_index{ |t, i| (types[t] ||= []) << i}
#   plus_sign_range = data['Sign'].each_with_index.map {|v,i| i if v == "+"}.compact
#   plus_sign_range_2 = data['Sign_2'].each_with_index.map {|v,i| i if v == "+"}.compact
#   types.each do |type, collection|
#     case type
#     when 'Single_Resource'
#       png range: collection, file: data["Color"].map {|c| c = 'empty' if c.to_s.size != 1; "icons/cubes/#{c}_full.png"}, layout: 'cube_large', x: 8.75.blocks, y: 18.blocks
#       rect range: collection, layout: 'ally_alt'
#       text range: collection, str: 'Trash from hand:', layout: 'ally_alt_text', font: 'Raleway'
#       png range: collection, file: "icons/cubes/X.png", layout: 'cube', x: 15.blocks, y: 24.blocks
#       text range: collection, str: 3, layout: 'cube_cost', x: 15.blocks, y: 24.5.blocks
#     when 'Double_Resource'
#       png range: collection, file: data['Color'].map {|colors| "icons/cubes/#{colors.split('').first}_full.png" if colors.to_s.size == 2}, layout: 'cube_large', x: 5.5.blocks, y: 18.blocks
#       png range: collection, file: data['Color'].map {|colors| "icons/cubes/#{colors.split('').last}_full.png" if colors.to_s.size == 2}, layout: 'cube_large', x: 11.5.blocks, y: 18.blocks
#       rect range: collection, layout: 'ally_alt'
#       text range: collection, str: 'Trash from hand:', layout: 'ally_alt_text', font: 'Raleway'
#       png range: collection, file: 'icons/shield.png', layout: 'ally_alt_shield', x: 15.blocks, y: 24.blocks 
#       text range: collection, str: 1, layout: 'ally_alt_points'
#     when 'Bodyguard'
#       png range: collection, file: 'icons/dagger.png', layout: 'icon', x: 5.blocks, y: 20.blocks
#       line range: collection, x1: 10.blocks, y1: 24.5.blocks, x2: 11.5.blocks, y2: 20.5.blocks, stroke_width: 10
#       png range: collection, file: 'icons/shield.png', layout: 'icon', x: 12.blocks, y: 20.blocks
#       text range: collection, str: '-2', layout: 'icon', x: 12.blocks, y: 21.blocks, font_size: 24, align: 'center'
#     when 'Single_Attribute'
#       png range: collection, file: data['Icon'].map {|i| i ||= 'empty'; "icons/#{i}.png"}, layout: 'icon', x: 8.blocks, y: 20.blocks
#       line range: collection, x1: 13.25.blocks, y1: 21.blocks, x2: 14.25.blocks, y2: 21.blocks, stroke_width: 6
#       line range: collection & plus_sign_range, x1: 13.75.blocks, y1: 20.5.blocks, x2: 13.75.blocks, y2: 21.5.blocks, stroke_width: 6
#       text range: collection, str: data['Number'], x: 13.25.blocks, y: 19.75.blocks, width: 3.blocks, height: 3.blocks, align: 'center', font_size: 18
#     when 'Double_Attribute'
#       png range: collection, file: data['Icon'].map {|i| i ||= 'empty'; "icons/#{i}.png"}, layout: 'icon', x: 4.blocks, y: 19.5.blocks
#       line range: collection, x1: 9.25.blocks, y1: 20.5.blocks, x2: 10.25.blocks, y2: 20.5.blocks, stroke_width: 6
#       line range: collection & plus_sign_range, x1: 9.75.blocks, y1: 20.blocks, x2: 9.75.blocks, y2: 21.blocks, stroke_width: 6
#       text range: collection, str: data['Number'], x: 9.25.blocks, y: 19.25.blocks, width: 3.blocks, height: 3.blocks, align: 'center', font_size: 18
# 
#       # second icons
#       png range: collection, file: data['Icon_2'].map {|i| i ||= 'empty'; "icons/#{i}.png"}, layout: 'icon', x: 12.blocks, y: 19.5.blocks
#       line range: collection, x1: 17.25.blocks, y1: 20.5.blocks, x2: 18.25.blocks, y2: 20.5.blocks, stroke_width: 6
#       line range: collection & plus_sign_range_2, x1: 17.75.blocks, y1: 20.blocks, x2: 17.75.blocks, y2: 21.blocks, stroke_width: 6
#       text range: collection, str: data['Number_2'], x: 17.25.blocks, y: 19.5.blocks, width: 3.blocks, height: 3.blocks, align: 'center', font_size: 18
#     end
#   end
#   
#   # draw_grid!
# 
#   save_png prefix: 'allies_'
#   # save_sheet sprue: 'a4_usa_card.yml', prefix: 'allies_sheet_'
#   save_pdf file: 'allies.pdf', prefix: 'allies_'
# end
# 
# Squib::Deck.new width: 825, height: 1125, cards: 60, layout: 'layout.yml' do
#   rect layout: 'cut', fill_color: COLORS['bill_border']
#   rect layout: 'bleed', fill_color: COLORS['bill_background']
#   data = xlsx file: 'data/bills.xlsx', explode: 'Quantity'
# 
#   png file: 'icons/scroll_white.png', layout: 'icon'
#   rect x: 9.25.blocks, y: 2.blocks, width: 10.75.blocks, height: 6.25.blocks, stroke_width: 0, fill_color: COLORS['bill_veto']
#   line x1: 10.25.blocks, y1: 4.25.blocks, x2: 12.25.blocks, y2: 6.25.blocks, stroke_width: 10, stroke_color: 'black'
#   line x1: 10.25.blocks, y1: 6.25.blocks, x2: 12.25.blocks, y2: 4.25.blocks, stroke_width: 10, stroke_color: 'black'
#   circle x: 13.25.blocks, y: 4.75.blocks, radius: 6, fill_color: 'black'
#   circle x: 13.25.blocks, y: 5.75.blocks, radius: 6, fill_color: 'black'
#   png file: data["Veto_Color"].map {|c| "icons/cubes/#{c}.png"}, layout: 'cube_large', x: 14.blocks, y: 2.75.blocks
#   text str: data["Veto_Cost"], layout: 'cube_cost_large', x: 14.blocks, y: 3.5.blocks
# 
#   # text str: data["Name"], layout: 'title'
# 
#   # rect layout: 'art', height: 5.blocks
#   # text str: 'Art', layout: 'art_text'
# 
#   png file: data['Color_1'].map {|c| "icons/cubes/#{c}.png"}, layout: 'cube_large', x: 3.blocks, y: 9.5.blocks
#   text str: data['Cost_1'], layout: 'cube_cost_large', x: 3.blocks, y: 10.25.blocks
#   png file: 'icons/shield.png', layout: 'shield_large', x: 14.blocks, y: 9.5.blocks
#   text str: data['Reward_1'], layout: 'shield_text_large', x: 14.blocks, y: 10.5.blocks
#   line x1: 9.blocks, x2: 13.blocks, y1: 12.blocks, y2: 12.blocks, stroke_width: 10
#   triangle x1: 12.5.blocks, y1: 11.5.blocks, x2: 12.5.blocks, y2: 12.5.blocks, x3: 13.5.blocks, y3: 12.blocks, fill_color: 'black'
# 
#   png file: data['Color_2'].map {|c| "icons/cubes/#{c}.png"}, layout: 'cube_large', x: 3.blocks, y: 16.blocks
#   text str: data['Cost_2'], layout: 'cube_cost_large', x: 3.blocks, y: 16.75.blocks
#   png file: 'icons/shield.png', layout: 'shield_large', x: 14.blocks, y: 16.blocks
#   text str: data['Reward_2'], layout: 'shield_text_large', x: 14.blocks, y: 17.blocks
#   line x1: 9.blocks, x2: 13.blocks, y1: 18.5.blocks, y2: 18.5.blocks, stroke_width: 10
#   triangle x1: 12.5.blocks, y1: 18.blocks, x2: 12.5.blocks, y2: 19.blocks, x3: 13.5.blocks, y3: 18.5.blocks, fill_color: 'black'
# 
#   png file: data['Color_3'].map {|c| "icons/cubes/#{c}.png"}, layout: 'cube_large', x: 3.blocks, y: 22.5.blocks
#   text str: data['Cost_3'], layout: 'cube_cost_large', x: 3.blocks, y: 23.25.blocks
#   png file: 'icons/shield.png', layout: 'shield_large', x: 14.blocks, y: 22.5.blocks
#   text str: data['Reward_3'], layout: 'shield_text_large', x: 14.blocks, y: 23.5.blocks
#   line x1: 9.blocks, x2: 13.blocks, y1: 25.blocks, y2: 25.blocks, stroke_width: 10
#   triangle x1: 12.5.blocks, y1: 24.5.blocks, x2: 12.5.blocks, y2: 25.5.blocks, x3: 13.5.blocks, y3: 25.blocks, fill_color: 'black'
# 
#   save_png prefix: 'bill_'
#   # save_sheet sprue: 'a4_usa_card.yml', prefix: 'bills_sheet_'
#   save_pdf file: 'bills.pdf', prefix: 'bills_'
# end
# 
# # events
# Squib::Deck.new width: 825, height: 1125, cards: 70, layout: 'layout.yml' do
#   rect layout: 'cut', fill_color: COLORS['event_border']
#   rect layout: 'bleed', fill_color: COLORS['event_background']
#   data = xlsx file: 'data/events.xlsx', explode: 'Quantity'
# 
#   png file: 'icons/event_white.png', layout: 'icon'
#   
#   costs = data["Cost"].map {|str| str.split('').each_slice(2) }
#   costs.each_with_index do |card_cost, card_number|
#     card_cost.each_with_index do |(number, color), index|
#       png range: card_number,
#         file: "icons/cubes/#{color}.png",
#         layout: 'cube_large',
#         x: 8.75.blocks + 6.blocks * index,
#         y: 3.blocks
#       text range: card_number,
#         layout: 'cube_cost_large',
#          str: number,
#          x: 8.75.blocks  + 6.blocks * index,
#          y: 3.75.blocks 
#     end
#   end
# 
#   first_divider_range = costs.map.with_index {|c, i| i if c.size > 1 }.compact
#   line range: first_divider_range, x1: 13.75.blocks, y1: 7.5.blocks, x2: 14.75.blocks, y2: 3.5.blocks, stroke_width: 10
# 
#   # text str: data["Name"], layout: 'title'
# 
#   # rect layout: 'art', height: 5.blocks
#   # text str: 'Art', layout: 'art_text'
# 
#   text str: data['Text'], layout: 'title', y: 10.blocks, font: 'Raleway'
# 
#   types = {}; data['Type'].each_with_index{ |t, i| (types[t] ||= []) << i}
#   plus_sign_range = data['Votes_Sign'].each_with_index.map {|v,i| i if v == "+"}.compact
#   plus_sign_range_2 = data['Votes_Sign_2'].each_with_index.map {|v,i| i if v == "+"}.compact
#   types.each do |type, collection|
#     case type
#     when 'Votes'
#       png range: collection, file: "icons/scroll_white.png", layout: 'icon', x: 5.blocks, y: 13.5.blocks
#       line range: collection, x1: 10.5.blocks, y1: 16.blocks, x2: 12.5.blocks, y2: 16.blocks, stroke_width: 10
#       line range: collection & plus_sign_range, x1: 11.5.blocks, y1: 15.blocks, x2: 11.5.blocks, y2: 17.blocks, stroke_width: 10
#       png range: collection & plus_sign_range, file: data["Votes_Color"].map {|c| c ||= 'empty'; "icons/cubes/#{c}.png" }, layout: 'cube_large', x: 13.blocks, y: 13.5.blocks
#       png range: collection - plus_sign_range, file: data["Votes_Color"].map {|c| c ||= 'empty'; "icons/cubes/#{c}_full.png" }, layout: 'cube_large', x: 13.blocks, y: 13.5.blocks
#       text range: collection & plus_sign_range, str: data["Votes_Number"], layout: 'cube_cost_large', x: 13.blocks, y: 14.25.blocks
#     when 'Assassinate'
#       png range: collection, file: 'icons/dagger.png', layout: 'icon', x: 8.5.blocks, y: 13.5.blocks
#     when 'Attribute'
#       png range: collection, file: data['Icon'].map {|i| i ||= 'empty'; "icons/#{i}.png"}, layout: 'icon', x: 8.blocks, y: 13.blocks
#       line range: collection, x1: 13.25.blocks, y1: 14.blocks, x2: 14.25.blocks, y2: 14.blocks, stroke_width: 6
#       line range: collection & plus_sign_range, x1: 13.75.blocks, y1: 13.5.blocks, x2: 13.75.blocks, y2: 14.5.blocks, stroke_width: 6
#       text range: collection, str: "1", x: 13.25.blocks, y: 12.75.blocks, width: 3.blocks, height: 3.blocks, align: 'center', font_size: 18
#     when 'Double_Attribute'
#       png range: collection, file: data['Icon'].map {|i| i ||= 'empty'; "icons/#{i}.png"}, layout: 'icon', x: 4.blocks, y: 12.5.blocks
#       line range: collection, x1: 9.25.blocks, y1: 13.5.blocks, x2: 10.25.blocks, y2: 13.5.blocks, stroke_width: 6
#       line range: collection & plus_sign_range, x1: 9.75.blocks, y1: 13.blocks, x2: 9.75.blocks, y2: 14.blocks, stroke_width: 6
#       text range: collection, str: "1", x: 9.25.blocks, y: 12.25.blocks, width: 3.blocks, height: 3.blocks, align: 'center', font_size: 18
# 
#       # second icons
#       png range: collection, file: data['Icon_2'].map {|i| i ||= 'empty'; "icons/#{i}.png"}, layout: 'icon', x: 12.blocks, y: 12.5.blocks
#       line range: collection, x1: 17.25.blocks, y1: 13.5.blocks, x2: 18.25.blocks, y2: 13.5.blocks, stroke_width: 6
#       line range: collection & plus_sign_range_2, x1: 17.75.blocks, y1: 13.blocks, x2: 17.75.blocks, y2: 14.blocks, stroke_width: 6
#       text range: collection, str: "1", x: 17.25.blocks, y: 12.5.blocks, width: 3.blocks, height: 3.blocks, align: 'center', font_size: 16
#     when 'Intrigue'
#       png range: collection, file: 'icons/ally.png', layout: 'icon', x: 4.5.blocks, y: 13.5.blocks
#       png range: collection, file: 'icons/steal.png', layout: 'icon', x: 11.5.blocks, y: 13.5.blocks
#     when 'Votes_All'
#       png range: collection, file: "icons/scroll_white.png", layout: 'icon', x: 5.blocks, y: 13.5.blocks
#       line range: collection, x1: 10.5.blocks, y1: 16.blocks, x2: 12.5.blocks, y2: 16.blocks, stroke_width: 10
#       line range: collection, x1: 11.5.blocks, y1: 15.blocks, x2: 11.5.blocks, y2: 17.blocks, stroke_width: 10
#       png range: collection, file: 'icons/cubes/X.png', layout: 'cube_large', x: 13.blocks, y: 13.5.blocks
#       text range: collection, str: 3, layout: 'cube_cost_large', x: 13.blocks, y: 14.25.blocks
#     end
#   end
# 
#   reward_riders = data['Rider_Reward'].map.with_index {|r, i| i if r}.compact
# 
#   # Reward riders
#   rect layout: 'rider', y: 21.75.blocks, fill_color: COLORS['bill_background'], height: 6.25.blocks
#   png range: reward_riders, file: data["Rider_Color"].map { |c| "icons/cubes/#{c}.png" }, layout: 'cube_large', x: 3.blocks, y: 22.5.blocks
#   text range: reward_riders, str: data["Rider_Cost"], layout: 'cube_cost_large', x: 3.blocks, y: 23.25.blocks
#   png range: reward_riders, file: 'icons/shield.png', layout: 'shield_large', x: 14.blocks, y: 22.5.blocks
#   text str: data["Rider_Reward"], layout: 'shield_text_large', x: 14.blocks, y: 23.25.blocks
#   line range: reward_riders, x1: 9.blocks, x2: 13.blocks, y1: 25.blocks, y2: 25.blocks, stroke_width: 10
#   triangle range: reward_riders, x1: 12.5.blocks, y1: 24.5.blocks, x2: 12.5.blocks, y2: 25.5.blocks, x3: 13.5.blocks, y3: 25.blocks, fill_color: 'black'
# 
#   # Veto riders
#   veto_riders = data['Rider_Reward'].map.with_index {|r, i| i if !r}.compact
#   rect layout: 'rider', range: veto_riders, y: 21.75.blocks, fill_color: COLORS['bill_veto'], height: 6.25.blocks
#   line range: veto_riders, x1: 10.25.blocks, y1: 24.blocks, x2: 12.25.blocks, y2: 26.blocks, stroke_width: 10, stroke_color: 'black'
#   line range: veto_riders, x1: 10.25.blocks, y1: 26.blocks, x2: 12.25.blocks, y2: 24.blocks, stroke_width: 10, stroke_color: 'black'
#   circle range: veto_riders, x: 13.25.blocks, y: 24.5.blocks, radius: 6, fill_color: 'black'
#   circle range: veto_riders, x: 13.25.blocks, y: 25.5.blocks, radius: 6, fill_color: 'black'
#   png range: veto_riders, file: data["Rider_Color"].map { |c| c ||= 'empty'; "icons/cubes/#{c}.png" }, layout: 'cube_large', x: 14.blocks, y: 22.25.blocks
#   text range: veto_riders, str: data["Rider_Cost"], layout: 'cube_cost_large', x: 14.blocks, y: 23.blocks
# 
#   save_pdf file: 'events.pdf', prefix: 'events_'
#   # save_sheet sprue: 'a4_usa_card.yml', prefix: 'events_sheet_'
#   save_png prefix: 'event_'
# end
