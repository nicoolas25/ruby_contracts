class FalseImplies
  include Contracts::DSL

  pre "true -> false" do implies(true, false) end
  def method1
  end
end

class TrueImplies
  include Contracts::DSL

  pre "false -> true" do implies(false, true) end
  def method1
  end

  pre "true -> true" do implies(true, true) end
  def method2
  end
end
