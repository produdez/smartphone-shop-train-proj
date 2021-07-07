# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#Creating Brands
brand_names = ['Samsung','Apple','Xiaomi','Microsoft','Google','Sony','BlackBerry']
brands = []
for b_name in brand_names
    brands.append(Brand.create(name: b_name))
end

#Creating OSs
os_names = [
    'IOS 13.1','IOS 12','IOS 10.1','IOS 14',
    'Windows 10', 'Windows 11',
    'MIUI 12.5.1', 'MIUI 9.0', 'Harmony',
    'Android 9.5','Android 10','Android 8','Android 4','Android 12',
    'BlackBerry OS 5.6', 'BlackBerry OS 1', 'BlackBerry OS 2.3',
    'Symbian OS 6.9','Symbian OS 7.0'
]
operating_systems = []
for os_name in os_names
    operating_systems.append(OperatingSystem.create(name: os_name))
end

# Creating Models
def create_model_relating_to_brand_os(brand, os_prefix)
    models = []
    brand_name = brand.name
    operating_systems = OperatingSystem.where('name LIKE ?', os_prefix + '%')
    operating_systems.each_with_index do |os, idx|
        model_name = brand_name[...3] + os.name
        models.append(Model.create({name: model_name, operating_system: os, brand: brand}))
    end
    return models
end

os_prefixes = ['Android','IOS', 'MIUI', 'Windows', 'Android', 'Symbian', 'BlackBerry']
models = []
Brand.all.each_with_index do |brand, idx|
    os_pref = os_prefixes[idx]
    models.concat(create_model_relating_to_brand_os(brand, os_pref))
end

#Creating Users
users = []
for i in 0..20
    role = i > 5 ? 'employee' : (i > 0 ? 'manager' : 'admin') # 1 admin, few managers and all employees
    users.append(User.create({email: "user#{i}@email.com", password:'password123', remember_created_at: Time.now, name: "User #{i}", role: role}))
end

#Stores and Employees
stores = []
employees = []
users.each_with_index do |user, idx|
    if user.role == 'manager'
        stores.append(Store.create({name: user.name + '\'s Store', location: "Location #{idx}", user: user}))
    elsif user.role == 'employee'
        choosen_store = stores[idx % stores.length] #select based on order
        employees.append(Employee.create({user: user, store: choosen_store}))
    end
end

#Colors
color_names = ['red', 'blue', 'purple', 'yellow', 'orange', 'white', 'black', 'green', 'neon', 'gray', 'pink', 'brown']
colors = []
for c_name in color_names
    colors.append(Color.create({name: c_name}))
end

#Predefined
conditions = ['99%', 'Like New', 'Old', 'Used Once', 'Brand New', '98%', 'Decently New', 'Usable']
manufacture_years = Array(2015..2021)
memory_sizes = [16, 24, 64, 96, 124, 186, 280, 514, 1024, 5000]
price_calc = lambda{ |cond, year, mem| return cond.length * 50.5 + (year - 2015) * 100.3 + mem * 50.11}
batch_sizes = [5,8,10,13,15,20]
batch_count = 100
#Phones
phones = []
for i in 0..batch_count
    color = colors[i % colors.length]
    store = stores[i % stores.length]
    model = models[i % models.length]

    cond = conditions[i % conditions.length]
    year = manufacture_years[i % manufacture_years.length]
    mem = memory_sizes[i % memory_sizes.length]
    batch = batch_sizes[i % batch_sizes.length]
    price = price_calc.call(cond, year, mem)
    phone_json = {manufacture_year: year, condition: cond, memory: mem, price: price, model: model, store: store, color: color}
    phones.concat(Phone.create(Array.new(batch, phone_json)))
end
