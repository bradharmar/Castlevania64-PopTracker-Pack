require 'pp'
require 'json'

location_mapping_path = File.expand_path('./scripts/autotracking/location_mapping.lua', __dir__)
content = File.read(location_mapping_path)

split_lines = content.split("\n")

def to_snake_case(string)
  string.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr('-', '_')
        .gsub(/\s+/, '_')
        .downcase
end

normalized_data = {}

split_lines.each do |line|
  unless line.include?("] = {")
    next
  end

  matches = line.match(/\{"(.*)"\}/)
  str = matches[1]

  area, *inner, check = str.split("/")

  name = area.gsub(/@/, '')

  filename = to_snake_case(name)


  data = normalized_data[filename] ||= {
    name: name,
    lines: [],
  }

  data[:lines] << {
    inner: inner,
    check: check
  }
end

def dig_into_children(current_acc, current_val, path, name)
  head, *rest = path

  item = current_acc.find do |i|
    i[:name] == name
  end

  if !item
    item = {
      name: name,
      access_rules: [],
      visibility_rules: [""],
      chest_unopened_img: "",
      chest_opened_img: "",
      children: [],
      sections: []
    }

    current_acc << item
  end

  if rest && rest.length > 0
    second, *r = rest
    dig_into_children(item[:children], current_val, rest, second)
  else
    current_val.each do |v|
      item[:sections] << {
        name: v[:check]
      }
    end
  end

  current_acc
end

normalized_data.map do |filename, value|
  location_data = {
    name: value[:name],
    access_rules: [],
    chest_unopened_img: "",
    chest_opened_img: "",
    sections: [],
  }

  grouped = value[:lines].group_by do |row|
    row[:inner]
  end

  grouped[[]]&.each do |section|
    location_data[:sections] << {
      name: section[:check],
      access_rules: [],
      visibility_rules: [""],
    }
  end

  children = grouped.reduce([]) do |accumulator, (path, d)|
    if path&.length > 0
      head, *rest = path
      dig_into_children(accumulator, d, path, head)
    else
      accumulator
    end
  end


  if children && children.length > 0
    location_data[:children] = children
  end

  data = [location_data]

  file_out_path = File.expand_path("./locations/#{filename}.json", __dir__)
  File.write(file_out_path, JSON.pretty_generate(data))
end

