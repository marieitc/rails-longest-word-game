require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array('A'..'Z').sample(10)
  end

  def english_word(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    response_serialized = URI.open(url).read
    response = JSON.parse(response_serialized)
    response['found']
  end

  def count_letters(attempt, grid)
    attempt_array = attempt.upcase.chars
    attempt_array.all? do |letter|
      attempt_array.count(letter) <= grid.count(letter) && grid.count(letter) != 0
    end
  end

  def score
    @attempt = params[:word]
    @letters = params[:letters]
    if count_letters(@attempt, @letters) && english_word(@attempt)
      @result = "Congratulations! #{@attempt} is a valid English word!"
    elsif count_letters(@attempt, @letters) && english_word(@attempt) == false
      @result = "Sorry but #{@attempt} does not seem to be a valid English word.."
    else
      @result = "Sorry but #{@attempt} can't be build out of #{@letters}"
    end
  end
end
