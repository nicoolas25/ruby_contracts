require_relative 'parent'

# Inherited method is redefined and a precondition is added.
class ChildWithAddedPrecondition < Parent
  pre "n >= (minimum_incr - 1).abs" do |n| n >= (minimum_incr - 1).abs end
  def increment(n)
    @value += n
  end
end
