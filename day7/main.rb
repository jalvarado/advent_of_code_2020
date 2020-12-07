class BagRule
  attr_accessor :amount, :bag
  def initialize(amount, bag)
    @amount = amount
    @bag = bag
  end
end

class Bag
  attr_accessor :color, :allowed_to_contain

  def initialize(color, allowed_to_contain = [])
    @color = color
    @allowed_to_contain = allowed_to_contain
  end

  def add_allowed_color(bag_rule)
    @allowed_to_contain << bag_rule
  end

  def can_contain?(color)
    @allowed_to_contain.any? do |bag_rule|
      bag_rule.bag.color == color || bag_rule.bag.can_contain?(color)
    end
  end

  def total_bag_count
    @allowed_to_contain.reduce(0) do |sum, bag_rule|
      sum += bag_rule.amount + bag_rule.amount * bag_rule.bag.total_bag_count
    end
  end
end

class Graph
  attr_accessor :nodes

  def initialize
    @nodes = []
  end

  def find_node(color)
    @nodes.detect { |n| n.color == color }
  end

  def find_or_create_node(color)
    node = @nodes.detect { |n| n.color == color }
    if node.nil?
      node = Bag.new(color)
      @nodes << node
    end
    node
  end
end

def parse_rule(rule)
  #puts "Parsing rule: #{rule}"

  container, allowed_colors = rule.split("contain")
  container_color = container.split(" bags").first
  re = /(\d+) (\w+ [\w]+) bags?[,.]/
  matches = allowed_colors.scan(re)
  [container_color, matches]
end

def print_graph(g)
  g.nodes.each do |node|
    puts "#{node.color}: #{node.allowed_to_contain}"
  end
end

def main
  rules = File.readlines("input/input.txt")
  #rules = File.readlines("input/test_input.txt")

  graph = Graph.new

  rules.each do |rule|
    bag_color, allowed_colors = parse_rule(rule)

    node = graph.find_or_create_node(bag_color)
    allowed_colors.each do |count, color|
      allowed_color = graph.find_or_create_node(color)
      node.add_allowed_color(BagRule.new(count.to_i, allowed_color))
    end
  end

  target_color = "shiny gold"
  #print_graph(graph)

  bag_count = graph.nodes.reduce(0) { |sum, node| node.can_contain?(target_color) ? sum += 1 : sum }
  puts "Part One: #{bag_count}"

  node = graph.find_node(target_color)
  puts "Part two: #{node.color} - #{node.total_bag_count}"

  #raise "Invalid part one result" unless bag_count == 238
end

if __FILE__ == $PROGRAM_NAME
  main
end
