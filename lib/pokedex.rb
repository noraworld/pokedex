# frozen_string_literal: true

require 'pokedex/version'
require 'pokedex/cli'
require 'pokedex/filter'
require 'json'

module Pokedex
  class Error < StandardError; end

  class << self
    def all
      File.join(root, 'data/pokedex.json').then do |name|
        File.open(name).then do |file|
          JSON.parse(file.read)
        end
      end
    end

    private

    def root
      Gem::Specification.find_by_name('pokedex').gem_dir
    end
  end
end
