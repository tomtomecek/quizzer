def snap!(options = {})
  path = options.fetch :path, "~/.Trash"
  file = options.fetch :file, "#{Time.now.to_i}.png"
  full = options.fetch :full, true

  path = File.expand_path path
  path = "/tmp" if !File.exists?(path)

  uri = File.join path, file

  page.driver.render uri, full: full
  system "open #{uri}"
end
