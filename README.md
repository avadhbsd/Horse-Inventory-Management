![Horse Logo](app/assets/images/admin/resized_logo.jpg)

# Horse

Shopify Inventory Management & Inisghts Dashboard

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

* Ruby v2.5.1
* Rails v5.2.2
* PostgreSQL v11.1

### Installing

```
$ bundle install
$ rails db:setup
```

## Running the tests

We are using [Rspec for Rails](https://github.com/rspec/rspec-rails).
We are currently testing
* Models
* Controllers
* Helpers

Current test coverage: **93.44%**

In order to run all of the tests, simply run the following:
```
$ rspec
```

### Coding style tests

We are using [Rubocop](https://github.com/rubocop-hq/rubocop), and are following the [Ruby Style Guide](https://github.com/rubocop-hq/ruby-style-guide)

In order to make sure the code follows the ruby style conventions, simpy run the following:
```
$ rubocop
```
