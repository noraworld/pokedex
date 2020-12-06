# frozen_string_literal: true

require 'pokedex'
require 'thor'

module Pokedex
  class CLI < Thor
    default_command :all

    desc '', 'yet'
    def all
      puts 'CLI is WIP!'
    end
  end
end
