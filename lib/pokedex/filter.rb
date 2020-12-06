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

    def name(*params, lang: nil)
      results = []

      params.each do |name|
        results += @pokemons.select do |pokemon|
          if lang
            pokemon['name'][lang].casecmp(name).zero?
          else
            pokemon['name'].keys.find do |key|
              pokemon['name'][key].casecmp(name).zero?
            end
          end
        end
      end

      @pokemons = results
      self
    end

    def fuzzy(*params, lang: nil)
      results = []

      params.each do |fuzzy_name|
        results += @pokemons.select do |pokemon|
          if lang
            pokemon['name'][lang].downcase.include?(fuzzy_name.downcase)
          else
            pokemon['name'].keys.find do |key|
              pokemon['name'][key].downcase.include?(fuzzy_name.downcase)
            end
          end
        end
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
    #
    # FIX: cannot find pokemons when order is opposite
    # it can find: ['fire', 'flying']
    # but it cannot find: ['flying', 'fire']
    def type(*params)
      @pokemons = params.map do |type|
        case type
        when String
          @pokemons.select { |pokemon| pokemon['type'].map(&:downcase).include?(type.downcase) }
        when Array
          @pokemons.select { |pokemon| pokemon['type'].map(&:downcase) == type.map(&:downcase) }
        else
          raise
        end
      end.flatten

      self
    end

    def region(*params, lang: nil)
      region_range = []

      params.each do |reg|
        if lang
          region_range += Pokedex.region.select { |region| region['name'][lang].casecmp(reg).zero? }.map { |r| r['range'] }
        else
          region_range += Pokedex.region.select { |region| region['name'].keys.find { |key| region['name'][key].casecmp(reg).zero? } }.map { |r| r['range'] }
        end
      end

      region_range.map! do |range|
        range['from']..range['to']
      end

      @pokemons = id(region_range).take
      self
    end

    def random(num = 1)
      @pokemons = @pokemons.sample(num)
      self
    end

    def ichooseyou!
      random(1).take
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
