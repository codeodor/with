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