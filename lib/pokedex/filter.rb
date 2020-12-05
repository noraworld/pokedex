# frozen_string_literal: true

module Pokedex
  class Filter
    attr_accessor :pokemons, :select

    def initialize
      @pokemons = Pokedex.all
      @select = nil
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
      unless @select.nil?
        selected = []

        @select.each do |s|
          if selected.empty?
            selected += @pokemons.map { |pokemon| pokemon.slice(s) }
          else
            @pokemons.each_with_index { |pokemon, index| selected[index].merge!(pokemon.slice(s)) }
          end
        end

        @pokemons = selected
      end

      @pokemons
    end

    def only(*params)
      @select = params
      self
    end

    def reset
      @pokemons = Pokedex.all
      self
    end
  end
end
