# Stretchr gem for Ruby

Easily interact with the stretchr restful data store.

## Usage

### Create a global session object

    stretchr = Stretchr.new(project: "project.company", private_key: "private_key", public_key: "public_key")

### Reading resources

    # get all cars
    cars = stretchr.cars.read

    if cars.success?
      cars.data.each do | car |
        # process each car
      end
    end

    # get 2nd page of cars ordered by name belonging to person 1
    ordered_cars = stretchr.people(1).cars.limit(10).page(2).order("-name")

    # get all books belonging to person 1
    books = stretchr.people(1).books.read

### Creating a resource

    if stretchr.people.create({ :name => "Ryan", :language => "Ruby" }).success?
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
