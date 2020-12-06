# frozen_string_literal: true

module Pokedex
  class Filter
    attr_accessor :pokemons, :include_keys, :exclude_keys

    def initialize
      @pokemons = Pokedex.all
      @include_keys = nil
      @exclude_keys = nil
    end

    def id(*params)
      results = []

      params.flatten.each do |id|
        case id
        when Integer
          results += @pokemons.select { |pokemon| pokemon['id'] == id }
        when Range
          results += @pokemons.select { |pokemon| pokemon['id'] >= id.first && pokemon['id'] <= id.last }
        else
          raise
        end
      end

      @pokemons = results
      self
    end

    def name(*params, lang: 'english')
      results = []

      params.each do |name|
        results += @pokemons.select { |pokemon| pokemon['name'][lang] == name.capitalize }
      end

      @pokemons = results
      self
    end

    # 'water'
    # ['grass', 'poison']
    # 'grass', 'poison'
    # ['grass'], ['poison']
    # ['grass'], 'poison'
    # ['grass', 'poison'], ['fire', 'flying']
    def type(*params)
      @pokemons = params.map do |type|
        case type
        when String
          @pokemons.select { |pokemon| pokemon['type'].include?(type.capitalize) }
        when Array
          @pokemons.select { |pokemon| pokemon['type'] == type.map(&:capitalize) }
        else
          raise
        end
      end.flatten

      self
    end

    def region(*params, lang: 'english')
      region_range = []

      params.each do |reg|
        region_range += Pokedex.region.select { |region| region['name'][lang] == reg.capitalize }.map { |r| r['range'] }
      end

      region_range.map! do |range|
        range['from']..range['to']
      end

      @pokemons = id(region_range).take
      self
    end

    def take
      raise "Both `only' and `except' are called. Choose either one." if @include_keys && @exclude_keys

      if @include_keys
        @pokemons.each do |pokemon|
          exclude_keys = pokemon.keys - @include_keys
          exclude_keys.each { |key| pokemon.delete(key) }
        end
      elsif @exclude_keys
        @exclude_keys.each { |key| @pokemons.each { |pokemon| pokemon.delete(key) } }
      end

      @pokemons
    end

    def only(*params)
      @include_keys = params
      self
    end

    def except(*params)
      @exclude_keys = params
      self
    end

    def reset
      @pokemons = Pokedex.all
      self
    end
  end
end
