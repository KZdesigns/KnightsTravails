module Searchable

    def dfs(target = nil, &prc)
        raise "must pass target or proc" if [target, prc].none?
        prc ||= Proc.new { |node| node.value == target }

        return self if prc.call(self)

        children.each do |child|
            result = child.dfs(&prc)
            return result unless result.nil?
        end

        nil
    end

    def bfs(target = nil, &prc)
        raise "must pass target or proc" if [target, prc].none?
        prc ||= Proc.new { |node| node.value == target }

        queue = [self]
        until queue.empty?
            el = queue.shift
            return el if prc.call(el)
            queue.concat(el.children)
        end

        nil
    end


end

class PolyTreeNode
    include Searchable

    def initialize(value)
        @value, @parent, @children = value, nil, []
    end

    def parent
        @parent
    end

    def children
        @children
    end

    def value
        @value
    end

    def parent=(parent)
        return if self.parent == parent

        if self.parent
            self.parent.children.delete(self)
        end

        @parent = parent

        self.parent.children << self unless self.parent.nil?
    end

    def add_child(child)
        child.parent = self
    end

    def remove_child(child)
        if !self.children.include?(child)
            raise "Node is not a child"
        end

        child.parent = nil
    end
end


