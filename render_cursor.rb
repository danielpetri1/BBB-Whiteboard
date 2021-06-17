#!/usr/bin/env ruby
# frozen_string_literal: true

require 'nokogiri'

start = Time.now

# Opens cursor.xml and shapes.svg
@cursor_reader = Nokogiri::XML::Reader(File.open('cursor.xml'))
@img_reader = Nokogiri::XML::Reader(File.open('shapes.svg'))

timestamps = []
cursor = []
dimensions = []

@cursor_reader.each do |node|
    timestamps << node.attribute('timestamp').to_f if node.name == 'event' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT

    cursor << node.inner_xml if node.name == 'cursor' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
end

@img_reader.each do |node|
    dimensions << [node.attribute('in').to_f, node.attribute('width').to_f, node.attribute('height').to_f] if node.name == 'image' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
end

File.open('timestamps/cursor_timestamps', 'w') do |file|
    timestamps.each.with_index do |timestamp, frame_number|
        # Get cursor coordinates
        pointer = cursor[frame_number].split

        # Skip iteration if cursor is not visible (slower!)
        # if pointer[0].to_f.negative? || pointer[1].to_f.negative?
        #   file.puts "#{timestamp} overlay@m x -16, overlay@m y -16;"
        #   next
        # end
        
        dimension = dimensions.select { |t, _, _| t <= timestamp }.pop

        width = dimension[1]
        height = dimension[2]

        # Calculate original cursor coordinates
        cursor_x = pointer[0].to_f * width
        cursor_y = pointer[1].to_f * height

        # Scaling required to reach target dimensions
        x_scale = 1600 / width
        y_scale = 1080 / height

        # Keep aspect ratio
        scale_factor = [x_scale, y_scale].min

        # Scale
        cursor_x *= scale_factor
        cursor_y *= scale_factor

        # Translate given difference to new on-screen dimensions
        x_offset = (1600 - scale_factor * width) / 2
        y_offset = (1080 - scale_factor * height) / 2

        cursor_x += x_offset
        cursor_y += y_offset

        # Move whiteboard to the right, making space for the chat and webcams
        cursor_x += 320

        # Writes the timestamp and position down
        file.puts "#{timestamp} overlay@m x #{cursor_x.round(3)}, overlay@m y #{cursor_y.round(3)};"
    end
end

finish = Time.now
puts finish - start
