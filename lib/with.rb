require 'with_sexp_processor'
require 'parse_tree'

class With
  VERSION = "0.0.1"
  def self.object(the_object, &block)
    @the_object = the_object
    @original_context = block.binding 
    
    anonymous_class = Class.new
    anonymous_class.instance_eval { define_method("the_block", block) }
    anonymous_class_as_sexp = ParseTree.translate(anonymous_class)
    
    our_block_sexp = anonymous_class_as_sexp[3][2][2]
    our_block_sexp = transform(our_block_sexp)
    
    transformed_block = lambda { eval(WithSexpProcessor.new.process(our_block_sexp)) } #, block.binding) }
    transformed_block.call
  end
  
  private
  def self.convert_single_statement_to_block(node)
    node = [:block, node] if node[0] != :block
    return node
  end
  
  def self.statements_to_process
    [:dasgn_curr, :lasgn, :fcall, :vcall]
  end
  
  def self.transform( node )
    node = convert_single_statement_to_block node 
    
    node.each_with_index do |statement, i|
      next if i == 0 
      
      statement_type = statement[0]  
      statement = self.method("transform_#{statement_type.to_s}").call(statement) if statements_to_process.include? statement_type 
      node[i] = statement 
    end
    
    return node
  end
  
  def self.transform_dasgn_curr statement
      var_name = statement[1].to_s
      value = statement[2]
      new_method = (var_name+"=").to_sym
      
      #binds to original context since we lose original_object name and cannot eval in that context
      value[1] = eval(value[1].to_s, @original_context) if (value[0]==:lvar || value[0]==:vcall) && !@the_object.respond_to?(value[1].to_s)
      
      if value[0]==:fcall
        func = value[1]
        args = value[2]
        arg_list = ""
        args.each_with_index do |arg, j|
          next if j == 0
          
          arg[1] = eval(arg[1].to_s, @original_context) if arg[0] != :lit
          
          arg_list << arg[1].to_s 
          arg_list << "," if j < args.length-1
        end
        funcall = "#{func}(#{arg_list})"
        
        value=[:lit, eval(funcall, @original_context)]  
      end
      
      statement = [:attrasgn, [:lvar, :the_object], new_method, value]
  end
  
  def self.transform_lasgn statement
      method = statement[2][1]
      if @the_object.respond_to?(method)
        lvar = statement[1]
        statement = [:lasgn, lvar, [:call, [:lvar, :the_object], method]]
      end
  end
  
  def self.transform_fcall statement
      method = statement[1]
      args = statement[2]
      args.each_with_index do |arg, j|
        next if j == 0
        arg[1] = eval(arg[1].to_s, @original_context) if arg[0] == :lvar && !@the_object.respond_to?(arg[1].to_s)
      end
      statement = [:call, [:lvar, :the_object], method, args]
  end
      
  def self.transform_vcall statement
    method = statement[1]
    statement = [:call, [:lvar, :the_object], method]
  end
    
end