module ApplicationHelper
  def brand_mapping
    Brand.all.collect { |brand| [brand.name, brand.id] }
  end

  def operating_system_mapping
    OperatingSystem.all.collect { |os| [os.name, os.id] }
  end

  def store_mapping
    Store.all.collect { |store| [store.name, store.id] }
  end

  def check_empty_hash(options)
    return true if options.blank?

    options = options.to_unsafe_h
    options.reduce(true) { |empty, (_key, val)| empty && val.empty? }
  end
end
