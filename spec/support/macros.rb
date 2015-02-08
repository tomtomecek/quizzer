def to_ids(*args)
  args.map { |a| a.id.to_s }
end

def click_away
  find(:xpath, "//body").click
end
