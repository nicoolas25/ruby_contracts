require_relative 'parent'

# Inherited method is redefined but with no added preconditons.
class ChildWithRedef < Parent
  def increment(n)
    @value += n
#TODO: bug demo    super(n)
  end
end
