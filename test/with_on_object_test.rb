require '../lib/with_on_object'
require 'test/unit'
require 'foo'

class TestWithOnObject < Test::Unit::TestCase

  def setup
    @foo = Foo.new
  end
  
  def test_With_works_with_attr_accessor_assignment
    foo = Foo.new
    with(foo) do 
      get = 'got!'
    end
    assert(foo.get == "got!")
  end
  
  def test_With_works_with_two_attr_accessor_assignments
    # Seems strange, but one line blocks don't show up as blocks after running through ParseTree, 
    # so this exercises the more common case, whereas the previous test exercises the uncommon one. 
    with(@foo) do 
      get = 'got!'
      a = 'b'
    end
    assert(@foo.get == "got!")
    assert(@foo.a == "b")
  end
  
  def test_With_works_with_method_call_no_args
    with(@foo) do 
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
    with(@foo) do 
      puts 
    end
    assert( true )
  end
  
  def test_With_works_with_assignment_to_outside_method_call_no_args
    def outter 
      5
    end 
    with(@foo) do 
      a = outter
    end
    
    assert(@foo.a == 5) 
  end

  def test_With_works_with_assignment_to_outside_lvar
    outter = "outside"
    with(@foo) do 
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
    with(@foo) do 
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
    with(@foo) do 
      a = f(x,y)
    end
    assert(@foo.a == 398)
  end
  
  
end