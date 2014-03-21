# Stretchr gem for Ruby

Easily interact with the Stretchr restful data store.

## Getting Started
to install stretchr, run:
```
gem install stretchr
```

Then, you can use it by:

```ruby
stretchr = Stretchr::Client.new({account: "company", project: "project", key: "public_key"})
```

### Specifying a host

If you're using your own Stretchr install, you can specify the hostname as follows:

```ruby
stretchr = Stretchr::Client.new({account: "account", project: "project", key: "public_key", hostname: "hostname.com"})
```

## Making requests

### Reading resources
```ruby
# get all cars
cars = stretchr.cars.get

if cars.success?
  cars.items.each do | car |
    # process each car
  end
end

# get 2nd page of cars ordered by name belonging to person 1
ordered_cars = stretchr.people(1).cars.limit(10).page(2).order("-name")

# get all books belonging to person 1
books = stretchr.people(1).books.get
```

### Using `at`
In addition to just stringing along your path, you can also set the path explicitely by using `at`
```ruby
car = stretchr.at("cars/123").get
```

### Reading a Single Resource

```ruby
# get a single car
car = stretchr.cars(123).get

if car.success?
  puts car.data["make"]
end
```

### Creating a resource

```ruby
if stretchr.people.create({ :name => "Ryan", :language => "Ruby" }).success?
  # success
else
  # handle errors
end
```

### Creating many resources
```ruby
if stretchr.people.create([{ :name => "Ryan", :language => "Ruby" }, {:name => "Tim", :language => "Java"}]).success?
  # success
else
  # handle errors
end
```

### Updating a resource

```ruby
if stretchr.people(123).update({:name => "Ryan Quinn"}).success?
  # success
else
  # handle errors
end
```

### Replacing a resource
```ruby
if stretchr.people(123).replace({:name => "Ryan Quinn"}).success?
  # success
else
  # handle errors
end
```

### Deleting a resource
```ruby
if stretchr.people(123).delete.success?
  # success
else
  # handle errors
end
```

### Delete many resources

```ruby
if stretchr.people.delete.success?
  # success
else
  # handle errors
end

# you can also use filters to limit what gets deleted

if stretchr.people.where("age", ">21").delete.success?
  #we've deleted everyone over 21
else
  # handle errors
end
```

## Filtering

### Data Filters

You can query data by including a `where` function in the request, for example:

```ruby
result = stretchr.books.where("name", "Life of Pi").get
# or
result = stretchr.books.where({name: "Life of Pi", author: "Yann Martel"}).get
```

You can use any of the query methods listed [in our docs](http://docs.stretchr.com/querying/filters.md#parameter-filtering).

Querying will always return an array, even there is only one resource found

### Paging, Limits and Sorting

```ruby
stretchr.people.limit(100).skip(100).order("-name,age")
```

Returns 100 people, numbers 101-200 ordered by name DESC and age ASC
```ruby
stretchr.people.limit(100).page(2)
```
You can also uses pages as a convenience method.  All this does is implement paging using the limit you set

### Other Filters
You can support any of the filters provided by stretchr by using the `param` method
```ruby
stretchr.people.param("include", "~parent").get
```

Full support for all stretchr filters can be viewed in the stretchr docs.
