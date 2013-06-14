require_relative 'parent'

class ChildWithRedef < Parent
  def increment(n)
    value += n
  end
end
