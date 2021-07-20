# frozen_string_literal: true

module ApplicationHelper # rubocop:todo Style/Documentation
  def brand_mapping
    Brand.all.collect { |brand| [brand.name, brand.id] }
  end

  def operating_system_mapping
    OperatingSystem.all.collect { |os| [os.name, os.id] }
  end

  def store_mapping
    Store.all.collect { |store| [store.name, store.id] }
  end

  def format_datetime(date_time)
    date_time.to_s(:long)
  end
end
