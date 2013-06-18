# Stretchr gem for Ruby

Easily interact with the stretchr restful data store.

## Usage

There are two ways you can interact with Stretchr using the Ruby SDK, you can interact with it directly using the client or you can interact with it based on resources, similar to what you may be used to from ActiveRecord

### Interacting with the Stretchr Client

    stretchr = Stretchr::Client.new(project: "project.company", private_key: "private_key", public_key: "public_key")

#### Reading resources

    # get all cars
    cars = stretchr.cars.get

    if cars.success?
      cars.data.each do | car |
        # process each car
      end
    end

    # get 2nd page of cars ordered by name belonging to person 1
    ordered_cars = stretchr.people(1).cars.limit(10).page(2).order("-name")

    # get all books belonging to person 1
    books = stretchr.people(1).books.read

#### Creating a resource

    if stretchr.people.create({ :name => "Ryan", :language => "Ruby" }).success?
      # success
    else
      # handle errors
    end

#### Creating many resources
    if stretchr.people.create([{ :name => "Ryan", :language => "Ruby" }, {:name => "Tim", :language => "Java"}]).success?
      # success
    else
      # handle errors
    end


#### Updating a resource

    if stretchr.people(123).update({:name => "Ryan Quinn"}).success?
      # success
    else
      # handle errors
    end

#### Replacing a resource

    if stretchr.people(123).replace({:name => "Ryan Quinn"}).success?
      # success
    else
      # handle errors
    end

#### Deleting a resource

    if stretchr.people(123).delete.success?
      # success
    else
      # handle errors
    end

#### Delete many resources

    if stretchr.people.delete.success?
      # success
    else
      # handle errors
    end

#### Searching for a resource
    result = stretchr.books.where("name" => "Life of Pi")
searching will always return an array, even there is only one resource found

### Interacting with Stretchr Resources
In addition to working with the api directly, you can also define your stretchr resources and then interact with them instead.  Behind the scenes, we're just using the client anyways, so a mixture of both is always an option.

#### Setup your Stretchr Config

    Stretchr.config do |s|
      s.project = "project-name"
      s.private_key = "private-key"
      s.public_key = "public-key"
      s.noisy_errors = true #optional, turns on error raising for error responses (including 404).  false by default
    end

#### Setup your resources
    class Books < Stretchr::Resource
      stretchr_config path: "/accounts/:account_id/books/:id"
    end

#### Creating resources
    book = Book.new({name: "Life of Pi"})
    book.save({account_id: "ryan"}) #saves the resource and updates with auto populated fields
    book.stretchr_id #= "stretchr-id-asdf"
    book.stretchr_created #= timestamp

Alternatively, you can create records directly

    book = Book.create({name: "Life of Pi"}, {account_id: "ryan"})
    book.name #= "Life of Pi"
    book.stretchr_id #= "stretchr-id-asdf"

You can also create resources in bulk

    books = Book.create([{name: "Life of Pi"}, {name: "Harry Potter"}], {account_id: "ryan"})
    books #= [Book, Book]
    books.first.name #= "Life of Pi"

#### Getting resources
    book = Book.find({account_id: "ryan", id: "stretchr-id-asdf"})
    book.name #= "Life of Pi"

#### Updating resources
    book = Book.find({account_id: "ryan", id: "stretchr-id-asdf"})
    book.name = "Life of Pi - edited"
    book.save #= updates the resources

#### Searching resources
    book = Book.where({"name" => "Life of Pi"})
    book #= [Book] always returns an array of results
You can use all the stretchr search parameters you know and love.

#### to_hash and to_json
You can convert resources to hashes and json, very useful for quick sinatra apps

    book = Book.find({account_id: "ryan", id: "stretchr-id-asdf"})
    book.to_hash
    book.to_json

Collections of resources can be converted to json using a map

    books = Book.all
    books.map {|b| b.to_hash }.to_json






