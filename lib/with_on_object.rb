require 'with'
class Object
  def with(object, &block)
    With.object(object, &block)
  end
end
    