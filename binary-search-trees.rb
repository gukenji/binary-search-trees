require 'pry-byebug'

class Node
    include Comparable
    attr_accessor :left, :data, :right
    def initialize(data)
        @data = data
        @left = nil
        @right = nil
    end
end

class Tree
    attr_accessor :root
    def initialize(array)
        @root = build_tree(array)
    end

    def build_tree(array)
        # binding.pry
        array.sort!
        return nil if array.length < 1
        array.length.modulo(2) != 0 ? mid = array[array.length/2] : mid = array[array.length/2-1]
        root = Node.new(mid)
        array.length.modulo(2) != 0 ? left = array[0...array.length/2] : left = array[0...array.length/2-1]
        array.length.modulo(2) != 0 ? right = array[array.length/2+1..] : right = array[array.length/2..]
        root.left = build_tree(left)
        root.right = build_tree(right)
        return root
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
      end

    def insert(value)
        root = @root
        previous = nil
        node = Node.new(value)
        until root.class == NilClass
            if root.data > value
                previous = root
                root = root.left
            else 
                previous = root
                root = root.right
            end
        end
        previous.data > value ? previous.left = node : previous.right = node
    end


    
    def delete(value)
        root = @root
        previous = nil
        until root.data == value
            if root.data > value
                previous = root
                root = root.left
            else 
                previous = root
                root = root.right
            end
        end
        if root.left == nil && root.right == nil
            previous.data > value ? previous.left = nil : previous.right = nil
        elsif (root.left != nil && root.right == nil) || (root.left == nil && root.right != nil)
            if previous.data > value
                root.left == nil ? previous.left = root.right : previous.left = root.left
            else
                root.left == nil ? previous.right = root.right : previous.right = root.left
            end
        else
            next_node = root.right
            until next_node.left == nil
                next_node = next_node.left
            end
            remove_node = next_node
            delete(remove_node.data)
            if previous != nil
                previous.data > value ? previous.left = next_node : previous.right = next_node
                next_node.left = root.left
                next_node.right = root.right
            else
               next_node.left = root.left
               next_node.right = root.right
               @root = next_node
            end
        end 
    end

    def find(value)
        node = @root
        until node.class == NilClass || node.data == value
            value > node.data ? node = node.right : node = node.left
        end
        node ? node : puts("Valor inexistente!")
    end

    def level_order(root=@root)
        level_order_list = []
        level_order_list << root
        i = 0
        until level_order_list[i] == nil
            if level_order_list[i].left != nil && level_order_list[i].right == nil
                level_order_list << level_order_list[i].left
                i += 1
            elsif level_order_list[i].left == nil && level_order_list[i].right != nil
                level_order_list << level_order_list[i].right
                i += 1
            elsif level_order_list[i].left == nil && level_order_list[i].right == nil         
                i += 1
            else 
                level_order_list << level_order_list[i].left
                level_order_list << level_order_list[i].right
                i += 1
            end
        end

        data_list = return_data_list(level_order_list)

        if block_given?
            level_order_list.each do |i|
                yield i.data
            end
        else
            data_list
        end
    end

    def preorder(root=@root,preorder_list=[])
        # DLR
        return if root == nil
        preorder_list << root
        preorder(root.left,preorder_list)
        preorder(root.right,preorder_list)
        data_list = return_data_list(preorder_list)
        if block_given?
            preorder_list.each do |i|
                yield i.data
            end
        else
            data_list
        end
    end

    def inorder(root=@root,inorder_list=[])
        # LDR
        return if root == nil
        inorder(root.left,inorder_list)
        inorder_list << root
        inorder(root.right,inorder_list)
        data_list = return_data_list(inorder_list)

        if block_given?
            inorder_list.each do |i|
                yield i.data
            end
        else
            data_list
        end
    end

    def postorder(root=@root,postorder_list=[])
        # LRD
        return if root == nil
        postorder(root.left,postorder_list)
        postorder(root.right,postorder_list)
        postorder_list << root
        data_list = return_data_list(postorder_list)

        if block_given?
            postorder_list.each do |i|
                yield i.data
            end
        else
            data_list
        end
    end

    def return_data_list(list)
        data_list = []
        for i in 0..list.length-1
            data_list << list[i].data
        end
        data_list
    end

    def height(node=@root,height=-1,list=[])
        # binding.pry
        return if node == nil
        height += 1
        height(node.left,height,list)
        height(node.right,height,list)
        list << height
        return list.max
    end     

    def depth(node,root=@root,depth=0)
        until root.class == NilClass || node.data == root.data 
            if node.data > root.data
                depth += 1
                root = root.right
            else
                depth += 1
                root = root.left
            end
        end
        root.class != NilClass ? depth : puts("Esse node não existe na arvore.")
    end

    def balanced?
        root = @root
        root.left != nil ? left_height = height(root.left) : left_height = 0
        root.right != nil ? right_height = height(root.right) : right_height = 0
        if (left_height - right_height).abs >= 2
            puts "Árvore desbalanceada!"
            return false
        else 
            puts "Árvore Balanceada!"
            return true
        end
    end

    def rebalance
        if balanced?
            puts "Tree already balanced!"
        else
            new_list = level_order
            @root = build_tree(new_list)
        end

    end
    
end


array = (Array.new(15) { rand(1..100) })
tree = Tree.new(array)
tree.pretty_print
tree.balanced?
puts "Preorder:"
p tree.preorder
puts "Postorder:"
p tree.postorder
puts "Inorder"
p tree.inorder
tree.insert(101)
tree.insert(102)
tree.insert(103)
tree.insert(104)
tree.insert(105)
tree.insert(106)
tree.insert(107)
tree.pretty_print
tree.balanced?
tree.rebalance
tree.pretty_print
tree.balanced?
puts "Preorder:"
p tree.preorder
puts "Postorder:"
p tree.postorder
puts "Inorder"
p tree.inorder
