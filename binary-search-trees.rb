require 'pry-byebug'

class Node
    include Comparable
    attr_accessor :left, :data, :right
    def initialize(data)
        @data = data
        @left = nil
        @right = nil
    end

    def set_left(node)
        @left = node
    end

    def set_right(node)
        @right = node
    end
end

class Tree
    attr_accessor :root
    def initialize(array)
        @root = build_tree(array)
    end

    def build_tree(array)
        # binding.pry
        return nil if array.length < 1
        mid = array[array.length/2]
        root = Node.new(mid)
        left = array[0...array.length/2]
        right = array[array.length/2+1..]
        root.set_left(build_tree(left))
        root.set_right(build_tree(right))
        return root
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
      end

end


array = [1,2,3,4,5,6]
tree = Tree.new(array)
root = tree.root

tree.pretty_print(root)

