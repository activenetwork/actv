require 'actv/base'

module ACTV
  class Suggestion < ACTV::Base
    attr_reader :text, :offset, :length, :options
  end
end