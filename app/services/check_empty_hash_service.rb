class CheckEmptyHashService
  def self.call(options)
    options.reduce(true) { |empty, (_key, val)| empty && val.empty? }
  end
end
