require 'rubygems'
require 'active_support/core_ext/hash/indifferent_access'
require "yaml"
require 'RMagick'

#
# Pass an image name and a list of attributes. An attribute has [:text, :x, :y] and 
# optionally can have [:font_size, :container_height, :container_width, :centered, 
# :color ]. It creates a jpeg image in ./images/#{image_name}.jpg
#
def make_card(image_name, things_to_put_on_it)    
    
    card = Magick::ImageList.new
    card.new_image(300, 400)
    
    puts "Doing #{image_name}..."
    things_to_put_on_it.each do | thing |
        text = Magick::Draw.new
        text_x = (thing[:x] || 0)
        text_y = (thing[:y] || 0)
        rotation = (thing[:rotation] || 0)
        game_text =  (thing[:text])
        game_text = game_text.to_s
        game_text = " " if game_text == ""

        color = (thing[:color] || "black")
        container_width = (thing[:container_width] || 0)
        container_height = (thing[:container_height] || 0)
        
        text.pointsize = (thing[:font_size] || 14)    
        text.gravity = Magick::CenterGravity if thing[:centered]

        text.annotate(card, container_width, container_height, text_x, text_y, game_text) {
            self.fill = color
            self.rotation = rotation
        }


    end
    
    card.write("images/#{image_name}.jpg")    
end

def wordwrap(txt, col=20)
    txt.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/, "\\1\\3\n").gsub(/\u2022$/, "") if txt
end


YAML::load(File.open('data/characters.yaml')).with_indifferent_access[:characters].each do | card | 

    card[:cost] = "\u00BA\n" * card[:cost]
    card[:class_element] = card[:element] + " " + card[:class]
    things_to_add = [
            { :text => card[:name], :x => 70, :y => 25, :font_size => 20 },
            { :text => card[:cost], :x => 25, :y => 25, :font_size => 20 },
            { :text => card[:energy], :x => 25, :y => 225, :font_size => 40 , :color=>"blue"},
            { :text => card[:health], :x => 25, :y => 275, :font_size => 40, :color=>"red" },
            { :text => card[:speed], :x => 25, :y => 325, :font_size => 40, :color=>"grey"},
            { :text => card[:class_element], :container_width => 300, :container_height => 20, :y=>200, :centered =>true },
            { :text => wordwrap(card[:skills].join(" \u2022 ")), :container_width => 300, :container_height => 20, :y => 240, :centered =>true  },
        ]
    make_card(card[:name], things_to_add)
end

YAML::load(File.open('data/items.yaml')).with_indifferent_access[:items].each do | card | 

    things_to_add = [
            { :text => card[:name], :x => 25, :y => 200, :font_size => 20, :rotation=>270 },
            { :text => card[:energy], :x => 25, :y => 225, :font_size => 40 , :color=>"blue"},
            { :text => card[:health], :x => 25, :y => 275, :font_size => 40, :color=>"red" },
            { :text => card[:type], :container_width => 300, :container_height => 20, :y=>200, :centered =>true },
            { :text => wordwrap(card[:text], 30), :container_width => 250, :container_height => 20, :x=>30, :y => 250, :centered =>true  },
        ]
    make_card(card[:name], things_to_add)
end

YAML::load(File.open('data/actions.yaml')).with_indifferent_access[:actions].each do | card | 

    things_to_add = [
            { :text => card[:name], :x => 70, :y => 25, :font_size => 20 },
            { :text => card[:energy], :x => 25, :y => 35, :font_size => 40 , :color=>"blue"},
            { :text => card[:type], :container_width => 300, :container_height => 20, :y=>200, :centered =>true },
            { :text => wordwrap(card[:text], 30), :container_width => 250, :container_height => 20, :x=>30, :y => 250, :centered =>true  },
        ]
    make_card(card[:name], things_to_add)
end

YAML::load(File.open('data/objectives.yaml')).with_indifferent_access[:objectives].each do | card | 

    things_to_add = [
            { :text => card[:name], :x => 250, :y => 25, :font_size => 20, :rotation=>90 },
            { :text => card[:health], :x => 125, :y => 25, :font_size => 40, :color=>"red" , :rotation=>90 },
            { :text => wordwrap(card[:text], 40), :container_width => 150, :container_height => 20, :x=>0, :y => 200, :centered =>true  , :rotation=>90 },
        ]
    make_card(card[:name], things_to_add)
end
