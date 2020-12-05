# frozen_string_literal: true

module Pokedex
  class Filter
    attr_accessor :pokemons

    def initialize
      @pokemons = Pokedex.all
    end

    def id(*params)
      results = []

      params.each do |id|
        results += @pokemons.select { |pokemon| pokemon['id'] == id }
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

    def take
      @pokemons
    end

    def reset
      @pokemons = Pokedex.all
      self
    end
  end
end
