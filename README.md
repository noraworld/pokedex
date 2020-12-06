# Pokedex
Search pokemons you want to know by CLI and Ruby interface.

:warning: This project is forked from [fanzeyi/pokemon.json](https://github.com/fanzeyi/pokemon.json), but independent.

:warning: **This project is WIP!** Stay tuned!

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'pokedex'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install pokedex
```

## Usage
Pokedex supports both CLI and Ruby interface. You can choose whichever you want.

In Ruby, you should add `require 'pokedex'`.

```ruby
require 'pokedex'
```

And in Ruby, method chaining is available.

```ruby
Pokedex::Filter.new.type('ice').region('sinnoh').random(3).only('name').take
```

### All
Retrieves all pokemons.

For CLI:
```bash
$ pokedex
```

For Ruby:
```ruby
Pokedex.all
```

### ID
Retrieves pokemons specified by its IDs.

```bash
$ pokedex 25,133
```

```ruby
Pokedex::Filter.new.id(25, 133).take
```

It is also available to specify pokemons by a range.

```bash
$ pokedex {100..199}
```

```ruby
Pokedex::Filter.new.id(100..199).take
```

### Name
Retrieves pokemons specified by its names.

```bash
$ pokedex growlithe,clefairy,vulpix,eevee
```

```ruby
Pokedex::Filter.new.name('growlithe', 'clefairy', 'vulpix', 'eevee').take
```

Also supports other languages. Languages are auto detected.

```ruby
Pokedex::Filter.new.name('growlithe', 'ピッピ', '六尾', 'évoli').take
```

Supported languages (currently):

- English
- Japanese
- Chinese
- French

You can also specify a language.

```ruby
Pokedex::Filter.new.name('growlithe', lang: 'english').take # => [{"id"=>58, "name"=>{"english"=>"Growlithe", "japanese"=>"ガーディ", "chinese"=>"卡蒂狗", "french"=>"Caninos"}, "type"=>["Fire"], "base"=>{"HP"=>55, "Attack"=>70, "Defense"=>45, "Sp. Attack"=>70, "Sp. Defense"=>50, "Speed"=>60}}]

# French name is not detected because the language is set as English
Pokedex::Filter.new.name('caninos', lang: 'english').take # => []
```

### Fuzzy
Retrieves pokemons specified by a part of its name. This is useful when the pokemon whose name you want to know is ambiguous.

```bash
$ pokedex --fuzzy=fla
```

```ruby
Pokedex::Filter.new.fuzzy('fla').take
```

You can also specify a language.

```ruby
# French name is excluded
Pokedex::Filter.new.fuzzy('fla', lang: 'english').take
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
Retrieves pokemons living in specific regions.

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
Pokedex::Filter.new.ichooseyou!(3)
```

The difference between `Pokedex::Filter#random` and `Pokedex::Filter#ichooseyou!` is whether it needs `Pokedex::Filter#take` or not.

```ruby
# These are the same (of course the results are different because these take pokemons at random)
Pokedex::Filter.new.region('johto').random.take
Pokedex::Filter.new.region('johto').ichooseyou!
```

### Only
Includes only specific keys from result.

```bash
$ pokedex --type=fairy --region=kalos --only=id,name
```

```ruby
Pokedex::Filter.new.type('fairy').region('kalos').only('id', 'name').take
```

### Except
Excludes specific keys from result.

```bash
$ pokedex --type=fairy --region=kalos --except=type,base
```

```ruby
Pokedex::Filter.new.type('fairy').region('kalos').except('type', 'base').take
```

### Reset
Deletes all filters. This is only available in Ruby.

```ruby
# Create a new instance
pokemons = Pokedex::Filter.new

# Gyarados is not a Dragon type
pokemons.type('dragon').name('gyarados').take # => []

# Reset all filters
pokemons.reset

pokemons.type('water').name('gyarados').take # => [{"id"=>130, "name"=>{"english"=>"Gyarados", "japanese"=>"ギャラドス", "chinese"=>"暴鲤龙", "french"=>"Léviator"}, "type"=>["Water", "Flying"], "base"=>{"HP"=>95, "Attack"=>125, "Defense"=>79, "Sp. Attack"=>60, "Sp. Defense"=>100, "Speed"=>81}}]
```

## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/noraworld/pokedex. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/noraworld/pokedex/blob/master/CODE_OF_CONDUCT.md).


## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct
Everyone interacting in the Pokedex project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/noraworld/pokedex/blob/master/CODE_OF_CONDUCT.md).
