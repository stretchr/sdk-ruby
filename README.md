# Stretchr gem for Ruby

Easily interact with the Stretchr restful data store.

## Getting Started
to install stretchr, run: 
```
gem install stretchr
```

Then, you can use it by:

```
stretchr = Stretchr::Client.new(project: "project.company", key: "public_key")
```

### Specifying a host

If you're using your own Stretchr install, you can specify the hostname as follows:

```
stretchr = Stretchr::Client.new(project: "project.company", key: "public_key", hostname: "hostname.com")
```

## Making requests

### Reading resources

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

### Reading a Single Resource
	# get a single car
    car = stretchr.cars(123).get

    if car.success?
      puts car.data["make"]
    end

### Creating a resource

    if stretchr.people.create({ :name => "Ryan", :language => "Ruby" }).success?
      # success
    else
      # handle errors
    end

### Creating many resources
    if stretchr.people.create([{ :name => "Ryan", :language => "Ruby" }, {:name => "Tim", :language => "Java"}]).success?
      # success
    else
      # handle errors
    end


### Updating a resource

    if stretchr.people(123).update({:name => "Ryan Quinn"}).success?
      # success
    else
      # handle errors
    end

### Replacing a resource

    if stretchr.people(123).replace({:name => "Ryan Quinn"}).success?
      # success
    else
      # handle errors
    end

### Deleting a resource

    if stretchr.people(123).delete.success?
      # success
    else
      # handle errors
    end

### Delete many resources

    if stretchr.people.delete.success?
      # success
    else
      # handle errors
    end

## Filtering

### Data Filters
```
result = stretchr.books.where("name" => "Life of Pi")
```
searching will always return an array, even there is only one resource found

### Paging, Limits and Sorting
```
stretchr.people.limit(100).skip(100).order("-name,age")
```

Returns 100 people, numbers 101-200 ordered by name DESC and age ASC
```
stretchr.people.limit(100).page(2)
```
You can also uses pages as a convenience method.  All this does is implement paging using the limit you set

### Other Filters
You can support any of the filters provided by stretchr by using the `param` method
```
stretchr.people.param("include", "~parent").get
```

Full support for all stretchr filters can be viewed in the stretchr docs.
