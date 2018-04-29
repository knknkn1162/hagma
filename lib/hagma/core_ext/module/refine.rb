class Module
  # Check if `self` owner is refinement module or not
  # if module is refinement module, its form is `#<refinement:Array@ArrayExt>`
  def refine?(mod)
    mod.to_s[2..-1].start_with?('refinement:')
  end
end
