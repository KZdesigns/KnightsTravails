require_relative '00_tree_node.rb' #=> giving access to PolyTreeNode class, creates nodes and has DFS and BFS

class KnightPathFinder #=> establishing a class
    
    MOVES = [
        [-2, -1],
        [-2,  1],
        [-1, -2],
        [-1,  2],
        [ 1, -2],
        [ 1,  2],
        [ 2, -1],
        [ 2,  1]
      ] #=> possibles moves for a knight from any given position
    

    def self.valid_moves(pos) #=> class method checking for all valid moves from the current position
        valid_moves = []

        cur_x, cur_y = pos
        MOVES.each do |dx, dy|
            new_pos = [cur_x + dx, cur_y + dy] #=> iterrating through all possible moves and creating a new move

            if new_pos.all? { |coord| coord.between?(0,7) } #=> if new moves are located on the board
                valid_moves << new_pos #=> adding the new move into the valid moves array
            end
        end

        valid_moves
    end

    def initialize(starting_pos) #=> initialzing the class with starting_pos i.e kpf = KnightPathFinder.new([0, 0])
        @starting_pos = starting_pos #=> sets the @starting_pos instance variable to position passed through
        @considered_positions = [start_pos] #=> sets @considered_positions instance variable
    end

    def build_move_tree #=> builds possible move tree to search through
        self.root_node = PolyTreeNode.new(start_pos) #=> setting root_node to starting position

        #=> taking BFS strategy
        nodes = [root_node] #=> initializing the queue
        until nodes.empty?
            current_node = nodes.shift #=> dequeuing 

            current_pos = current_node.value
            new_move_positions(current_pos).each do |next_pos|
                next_node = PolyTreeNode.new(next_pos)
                current_node.add_child(next_node)
                nodes << next_node #=> enqueuing 
            end
        end
    end

    def new_move_positions(pos) #=> adds possible moves to the considered_positions array unless the position already exsists
        KnightPathFinder.valid_moves(pos)
        .reject { |new_pos| considered_positions.include?(new_pos) }
        .each { |new_pos| considered_positions << new_pos }
    end

end