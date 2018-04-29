class Module
  # Check if `self` owner is refinement module or not
  # if module is refinement module, its form is `#<refinement:Array@ArrayExt>`
  def refine?
    to_s.start_with?('#<refinement:')
  end
end
