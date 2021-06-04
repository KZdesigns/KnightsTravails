require_relative '00_tree_node' #=> provides access to PolyTree class

class KnightPathFinder
  attr_reader :start_pos #=> gives read access to @start_pos

  MOVES = [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1]
  ] #=> possible move combinations at any posistion

  def self.valid_moves(pos) #=> method to find valid moves
    valid_moves = [] #=> establishing an array to hold valid moves

    cur_x, cur_y = pos #=> assigning the pos to x, and y values
    MOVES.each do |(dx, dy)| #=> iterating through move combinations
      new_pos = [cur_x + dx, cur_y + dy] #=> creating new combos

      if new_pos.all? { |coord| coord.between?(0, 7) } #=> if the combos are within the board 
        valid_moves << new_pos #=> then add the pos combo to the array of valid moves
      end
    end

    valid_moves #=> return valid moves array
  end

  def initialize(start_pos) #=> initializing the new
    @start_pos = start_pos #=> setting the start_pos to an instance variable
    @considered_positions = [start_pos] #=> initializing the considered positions array [start_pos]

    build_move_tree #=> and build tree
  end

  def find_path(end_pos) #=> finds the fasted path
    end_node = root_node.dfs(end_pos) #=> used DFS to find fastest path end_pos or node

    trace_path_back(end_node) #=> traceback the path to the end 
      .reverse #=> reverses the order to it goes start to end
      .map(&:value) #=> maps each node to just the value
  end

  private_constant :MOVES #=> establishes a constant

  private

  attr_accessor :root_node, :considered_positions #=> give read write acces to root_node, considered_pos

  def build_move_tree #=> build the tree
    self.root_node = PolyTreeNode.new(start_pos) #=> root_node set to the start pos

    # build the tree out in breadth-first fashion
    nodes = [root_node]
    until nodes.empty?
      current_node = nodes.shift

      current_pos = current_node.value
      new_move_positions(current_pos).each do |next_pos|
        next_node = PolyTreeNode.new(next_pos)
        current_node.add_child(next_node)
        nodes << next_node
      end
    end
  end

  def new_move_positions(pos) #=> creating new possible postions
    KnightPathFinder.valid_moves(pos)
      .reject { |new_pos| considered_positions.include?(new_pos) }
      .each { |new_pos| considered_positions << new_pos }
  end

  def trace_path_back(end_node) #=> creates an array of all the nodes to get to the end node
    nodes = []

    current_node = end_node
    until current_node.nil?
      nodes << current_node
      current_node = current_node.parent
    end

    nodes
  end
end

if $PROGRAM_NAME == __FILE__ #=> runs runs the program
  kpf = KnightPathFinder.new([0, 0])
  p kpf.find_path([7, 6])
  p kpf.find_path([6, 2])
end
