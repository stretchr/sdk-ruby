# Stretchr gem for ruby

Easily interact with the stretchr restful data store.

## Usage

    stretchr = Stretchr.new(project: "company.project", private_key: "private_key", public_key: "public_key")
    stretchr.people(1).cars
    stretchr.people(1).cars.limit(10).page(2).order("-name")

# Coming Soon

## Saving records

    person = stretchr.people(1)
    person.name = "Ryan"
    person.save

## Filters

    stretchr.people.where(name: "Ryan", age: ">30")

## Creating new records

    stretchr.people << {name: "Ryan", age: "25"}
