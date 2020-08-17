require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10).map { |char| char.upcase }
  end

  def score
    @letters = params[:letters]
    @word = params[:word].upcase
    run_game
  end

  def run_game
    dictionary = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{@word}").read)
    check = @word.split(//).all? { |char| @word.count(char) <= @letters.count(char) }
    messages(dictionary, check)
  end

  def messages(dictionary, check)
    if check
      if dictionary['found']
        @result = "Congratulations! #{@word} is a valid English word!"
      else
        @result = "Sorry, but #{@word} does not seem to be a valid English word..."
      end
    else
      @result = "Sorry, but #{@word} can't built out of #{@letters}"
    end
  end
end
