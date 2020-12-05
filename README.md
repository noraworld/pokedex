# Pokedex
Search pokemons you want to know by CLI and Ruby interface.

:warning: **This project is WIP!** Stay tuned!

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'pokedex'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install pokedex

## Usage
Pokedex supports both CLI and Ruby interface. You can choose whichever you want.

In Ruby, you should add `require 'pokedex'`.

```ruby
require 'pokedex'
```

### All
Retrieves all pokemons.

```bash
$ pokedex
```

```ruby
Pokedex.all
```

### ID
Retrieves pokemons specified by its IDs.

```bash
$ pokedex 25,133
```

For Ruby:
```ruby
Pokedex::Filter.new.id(25, 133).take
```

It is also available to specify pokemons by a range.

```bash
$ pokedex {100..200}
```

```ruby
Pokedex::Filter.new.id(100..199).take
```

### Name
Retrieves pokemons specified by its name.

```bash
$ pokedex eevee,clefairy
```

```ruby
Pokedex::Filter.new.name('eevee', 'clefairy').take
```

Also supports other languages.

```ruby
Pokedex::Filter.new.name('イーブイ', 'ピッピ', lang: 'japanese').take
```

### Type
Retrieves pokemons categorized as specific types.

This below is an example for taking pokemons categorized as a **Water** type.
```bash
$ pokedex --type=water
```

```ruby
Pokedex::Filter.new.type('water').take
```

#### and
This example gets pokemons categorized as **Grass and Poison** types.

```bash
$ pokedex --type={grass,poison}
```

```ruby
Pokedex::Filter.new.type(['grass', 'poison']).take
```

Please note that this doesn’t contain the pokemons categorized as **Grass and other type except for Poison** and **only Grass** type etc.

#### or
This example gets pokemons categorized as **Grass or Poison** types.

```bash
$ pokedex --type=grass,poison
```

```ruby
Pokedex::Filter.new.type('grass', 'poison').take
```

Please note that this also contains the pokemons categorized as **Grass and other type** and **Poison and other type**.

#### single
This example gets pokemons categorized as **only Grass** type and **only Poison** type.

```bash
$ pokedex --type={grass},{poison}
```

```ruby
Pokedex::Fileter.new.type(['grass'], ['poison']).take
```

Please note that this doesn’t contain the pokemons categorized as **Grass and other type** and **Poison and other type**.

#### and/or
This example gets pokemons categorized as **Grass and Poison** types or **Fire and Flying** types.

```bash
$ pokedex --type={grass,poison},{fire,flying}
```

```ruby
Pokedex::Fileter.new.type(['grass', 'poison'], ['fire', 'flying']).take
```

### Region
Retrieves pokemons living in a specific region.

```bash
$ pokedex --region=hoenn,unova
```

```ruby
Pokedex::Filter.new.region('hoenn', 'unova').take
```

Also supports other languages.

```ruby
Pokedex::Filter.new.region('ホウエン', 'イッシュ', lang: 'japanese').take
```

### Random
Retrieves pokemons at random. Specifies argument which is the number of pokemons to be chosen (default is `1`).

```bash
$ pokedex --random=3
```

```ruby
Pokedex::Filter.new.random(3).take
```

In Ruby, this is also available.

```ruby
Pokedex::Filter.new.ichooseyou!(3).take
```

The differences between `Pokedex::Filter#random` and `Pokedex::Filter#ichooseyou!` are whether it’s a destructive method or not, and whether it needs `Pokedex::Filter#take` or not.

```ruby
# These are same
Pokedex::Filter.new.random.take
Pokedex::Filter.new.ichooseyou!
```

```ruby
# These are NOT same
Pokedex::Filter.new.region('johto').random.take
Pokedex::Filter.new.region('johto').ichooseyou!
```

`Pokedex::Filter#ichooseyou!` targets at all pokemons even if an instance is already filtered.

```ruby
# These are same (tricky)
Pokedex::Filter.new.region('johto').ichooseyou!
Pokedex::Filter.new.ichooseyou!
```

### Fuzzy
Retrieves pokemons specified by a part of its name. This is useful when the pokemon whose name you want to know is ambiguous.

```bash
$ pokedex --fuzzy=dod
```

```ruby
Pokedex::Filter.new.fuzzy('dod').take
```

### only
Include only specific keys from result.

```bash
$ pokedex --type=fairy --region=kalos --only=id,name
```

```ruby
Pokedex::Filter.new.type('fairy').region('kalos').only('id', 'name').take
```

### except
Excludes specific keys from result.

```bash
$ pokedex --type=fairy --region=kalos --except=type,base
```

```ruby
Pokedex::Filter.new.type('fairy').region('kalos').except('type', 'base').take
```

## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pokedex. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/pokedex/blob/master/CODE_OF_CONDUCT.md).


## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct
Everyone interacting in the Pokedex project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pokedex/blob/master/CODE_OF_CONDUCT.md).
