# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Creating Brands
brand_names = %w[Samsung Apple Xiaomi Microsoft Google Sony BlackBerry]
brand_names.each do |b_name|
  Brand.create(name: b_name)
end

# Creating OSs
os_names = [
  'IOS 13.1', 'IOS 12', 'IOS 10.1', 'IOS 14',
  'Windows 10', 'Windows 11',
  'MIUI 12.5.1', 'MIUI 9.0', 'Harmony',
  'Android 9.5', 'Android 10', 'Android 8', 'Android 4', 'Android 12',
  'BlackBerry OS 5.6', 'BlackBerry OS 1', 'BlackBerry OS 2.3',
  'Symbian OS 6.9', 'Symbian OS 7.0'
]

os_names.each do |os_name|
  OperatingSystem.find_or_create_by(name: os_name)
end

# Creating Models
def create_model_relating_to_brand_os(brand, os_prefix)
  models = []
  brand_name = brand.name
  operating_systems = OperatingSystem.where('name LIKE ?', "#{os_prefix}%")
  operating_systems.each_with_index do |os, _idx|
    model_name = brand_name[...3] + os.name
    models.append(Model.find_or_create_by(name: model_name, operating_system: os, brand: brand))
  end
  models
end

os_prefixes = %w[Android IOS MIUI Windows Android Symbian BlackBerry]
models = []
Brand.find_each.with_index do |brand, idx|
  os_pref = os_prefixes[idx]
  models.concat(create_model_relating_to_brand_os(brand, os_pref))
end

# Creating Users
users = []
def find_or_create_user(user)
  if User.exists?(email: user[:email])
    User.find_by(email: user[:email])
  else
    User.create(user)
  end
end

# Admin
users.append(find_or_create_user({ email: 'admin@admin.com', password: 'adminadmin', remember_created_at: Time.now,
                                   name: 'ADMIN', role: 'admin'}))

# Stores and Managers
stores = []
(1..4).each do |i|
  users.append(find_or_create_user({ email: "manager#{i}@email.com", password: 'password123', remember_created_at: Time.now,
                                     name: "Manager #{i}", role: 'user' }))
  stores.append(Store.find_or_create_by(name: "Store #{i}", location: "Location #{i}"))
  Staff.find_or_create_by(user: users[-1], store: stores[-1], role: 'manager')
end
# Employees
(1..15).each do |i|
  users.append(find_or_create_user({
                                     email: "employee#{i}@email.com", password: 'password123',
                                     remember_created_at: Time.now, name: "Employee #{i}", role: 'user'
                                   }))
  Staff.find_or_create_by(user: users[-1], store: stores[i % stores.length])
end

# Colors
color_names = %w[red blue purple yellow orange white black green neon gray pink brown]
colors = []
color_names.each do |c_name|
  colors.append(Color.find_or_create_by(name: c_name))
end

# Predefined phone attributes!
conditions = Phone::CONDITIONS
manufacture_years = Array(2015..2021)
memory_sizes = [16, 24, 64, 96, 124, 186, 280, 514, 1024, 5000]
price_calc = ->(cond, year, mem) { return cond.length * 50.5 + (year - 2015) * 100.3 + mem * 50.11 }
batch_sizes = [5, 8, 10, 13, 15, 20]
batch_count = 100
# Phones
(0..batch_count).each do |i|
  color = colors[i % colors.length]
  store = stores[i % stores.length]
  model = models[i % models.length]

  cond = conditions[i % conditions.length]
  year = manufacture_years[i % manufacture_years.length]
  mem = memory_sizes[i % memory_sizes.length]
  batch = batch_sizes[i % batch_sizes.length]
  price = price_calc.call(cond, year, mem)
  phone_json = { manufacture_year: year, condition: cond, memory: mem, price: price, model: model, store: store,
                 color: color }

  Phone.create(Array.new(batch, phone_json))
end

# Set some phones to unavailable
update_batch_size = 10
update_off_set = 30
(0..30).each do |i|
  s_idx = i * update_off_set
  e_idx = s_idx + update_batch_size
  Phone.where(id: (s_idx..e_idx).to_a).update_all(status: 'unavailable')
end
