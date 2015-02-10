module ModalMacros
  def within_modal
    within(:css, ".modal") do
      yield
    end
  end
end
