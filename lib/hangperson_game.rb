class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  attr_reader :word
  attr_reader :guesses
  attr_reader :wrong_guesses
  
  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  def guess(letter)
    raise ArgumentError.new('letter must exist') if letter==nil or letter.empty?
    raise ArgumentError.new('letter must be alphabetic') if  /^[^a-zA-Z]$/ =~ letter
    
    letter.downcase!
    return false if (@guesses + @wrong_guesses).include? letter
    
    @guesses += letter if @word.include? letter
    @wrong_guesses += letter if not @word.include? letter
    return true
  end
  
  def word_with_guesses
    @word.each_char.map{ |c| if @guesses.include? c then c else '-' end }.join
  end
  
  def check_win_or_lose
    return :win if not word_with_guesses.include? '-'
    return :lose if @wrong_guesses.length >= 7
    return :play
  end

end
