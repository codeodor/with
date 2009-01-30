require 'ruby2ruby'

class WithSexpProcessor < Ruby2Ruby
  
  def process_vcall(exp)
    exp.shift.to_s
  end  
  
  def process(exp)
    hacked=true && hack_nil unless nil.respond_to? "empty?"
    result = super(exp)
    unhack_nil if hacked
    return result
  end
  
  private
  def hack_nil
    ::NilClass.module_eval do
      def empty?
        true
      end
    end
  end
  
  def unhack_nil
    ::NilClass.module_eval do
      def empty?
        throw NoMethodError, "undefined method `empty?' for nil:NilClass"
      end
    end
  end
end
