# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem "rails", path: './rails', require: false
end

FILES = [
  "rails/engine/configuration",
  "rails/source_annotation_extractor",
  "active_support/deprecation"
]

puts "#" * 60
puts "With Kernel.require"
FILES.each do |file|
  p Kernel.require(file)
end
puts

###########
module Kernel
  alias :original_require :require
  REQUIRE_STACK = []

  def require(file)
    Kernel.require(file)
  end

  # This breaks things, not sure how to fix
  # def require_relative(file)
  #   Kernel.require_relative(file)
  # end
  class << self
    alias :original_require          :require
    # alias :original_require_relative :require_relative
  end
end

puts "#" * 60
puts "With original_require"
FILES.each do |file|
  p original_require(file)
end
puts

puts "#" * 60
puts "With original_require and define_singleton_method"
FILES.each do |file|
  Kernel.define_singleton_method(:require) do |file|
    p original_require(file)
  end
end
