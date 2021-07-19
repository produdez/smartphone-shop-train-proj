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
end
