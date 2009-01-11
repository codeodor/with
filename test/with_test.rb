require '../lib/with'
require 'test/unit'

class Foo
  attr_accessor :get, :a, :b
  def initialize
    @get = "get!"
    @a = 'a'
    @b = 'b'
  end

  def show
    puts inspect
  end

  def change
    @a = "changed!"
  end

  def set(c, d)
    @a = c
    @b = d
  end
end


class TestWith < Test::Unit::TestCase

  def setup
    @foo = Foo.new
  end
  
  def test_With_works_with_attr_accessor_assignment
    foo = Foo.new
    With.object(foo) do 
      get = 'got!'
    end
    assert(foo.get == "got!")
  end
  
  def test_With_works_with_two_attr_accessor_assignments
    # Seems strange, but one line blocks don't show up as blocks after running through ParseTree, 
    # so this exercises the more common case, whereas the previous test exercises the uncommon one. 
    With.object(@foo) do 
      get = 'got!'
      a = 'b'
    end
    assert(@foo.get == "got!")
    assert(@foo.a == "b")
  end
  
  def test_With_works_with_method_call_no_args
    With.object(@foo) do 
      get = 'got!'
      change
    end
    assert(@foo.a == "changed!")
  end

  def test_With_works_with_method_call_with_args
    With.object @foo do
      set("c", "d")
      set("d", "e")
    end
    assert @foo.a == "d"
    assert @foo.b == "e"
  end
  
  def test_With_ignores_calls_to_methods_where_foo_respond_to?_is_false
    With.object(@foo) do 
      puts 
    end
    assert( true )
  end
  
  def test_With_works_with_assignment_to_outside_method_call_no_args
    def outter 
      5
    end 
    With.object(@foo) do 
      a = outter
    end
    
    assert(@foo.a == 5) 
  end

  def test_With_works_with_assignment_to_outside_lvar
    outter = "outside"
    With.object(@foo) do 
      outter = get
    end
    assert( outter == @foo.get ) 
    #this fails. unsure how / if it should stay as part of the spec
    #problem is that (as far as I can tell) it will need to evaluate the post-transformation 
    #block in the original context, whereas it currently needs to be executed in a diff one
    #this would be a lot easier - less transforms on other specs - if we could find the variable 
    #name of "@foo" within With.object
  end
  
  def test_With_works_with_assignment_to_outside_method_call_with_args
    def f(x,y)
      398
    end
    With.object(@foo) do 
      a = f(1,3)
    end
    assert(@foo.a == 398)
  end
  
  def test_With_works_with_method_call_with_args_using_non_literals
    def f(x,y)
      398
    end
    x = 2
    y = 5
    With.object(@foo) do 
      a = f(x,y)
    end
    assert(@foo.a == 398)
  end
  
  
end
