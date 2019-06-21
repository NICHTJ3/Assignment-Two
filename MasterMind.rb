#!/usr/bin/env ruby
# frozen_string_literal:true

##########################################
# Semester 1 2019                        #
# Programming 4 Assignment 2 Master Mind #
# Trent Nicholson                        #
##########################################

# TODO: Check this is correct casing for ruby
# Constants for gameplay
NUMBER_OF_ROUNDS = 1
WORD_FILE_LOCATION = 'mastermindWordList.txt'

# TODO: Extract this to another file
class Word
  def self.valid(word)
    word = word.chomp.downcase
    valid_length(word) && no_duplicates(word) && valid_characters_used(word)
  end

  # Checks if word supplied to the function is a valid length
  def self.valid_length(word)
    # Checks if word supplied to the function is five characters long
    word.length == 5
  end

  def self.no_duplicates(word)
    # Checks if all characters in the word appear one or less times
    ('a'..'z').all? { |char| word.count(char) <= 1 }
  end

  def self.valid_characters_used(word)
    word.split('').each do |letter|
      return false unless ('a'..'z').include? letter
    end
    true
  end
end

# TODO: Extract this to another file
class Game
  attr_accessor :words

  def instructions
    puts 'Instructions:'
    puts '	The computer will generate a random word,'
    puts '	This word will be 5 letters long and consist of only unique letters'
    puts '	Your job is to guess what it is.'
    puts '	Feedback for your guesses are'
    puts '	? near'
    puts '	. miss'
  end

  # TODO: Fix asssignment branch length
  def give_feedback(word)
    print 'Feedback: '
    word.chomp.chars.each_with_index do |char, index|
      if char == current_word.chomp.chars[index]
        print current_word.chomp.chars[index]
      elsif current_word.chomp.include? char
        print '?'
      else
        print '.'
      end
    end
    puts
  end

  def check_word_is_correct(guess)
    guess == @current_word
  end

  def gen_new_word
    @current_word = @words[rand(@words.count)]
  end

  # Reads the words from the mastermindWordList.txt file if it exists
  def self.read_words_from_file_if_exists
    if File.exist?(WORD_FILE_LOCATION)
      read_words_from_file
    else
      # Prints text to screen
      puts 'The mastermindWordList.txt was not found'
    end
  end

  def self.read_words_from_file
    # Creates an empty array for me to place valid words in
    words = []
    # Open the file for reading and close it when this block is finished
    File.open(WORD_FILE_LOCATION, 'r') do |words_file|
      # Read current line from file and saves it to a variable called word
      words_file.each_line do |word|
        # Adds the current word to the words array as lowercase also removes
        # new line character if it existsif it was valid
        Word.valid(word) && words << word.chomp.downcase
      end
    end
    words
  end

  def play(num_of_rounds)
    correct = false
    guesses = 0
    instructions
    until guesses == num_of_rounds || correct
      puts "You have #{num_of_rounds - guesses} guesses left"
      print 'Guess:    '
      # Get and store the players input in lowercase with no spaces first it
      # converts it to a string to avoid enter breaking the game
      guess = gets.to_s.chomp.downcase.strip
      if !Word.valid(guess)
        puts 'Invalid input. Guesses must be 5 characters long and contain no
        duplicate letters or symbols'
      else
        guesses += 1
        give_feedback(guess)
        correct = check_word_is_correct(guess)
      end
    end
    if correct
      puts 'Congratulations you guessed it :)'
    else
      puts 'Better luck next time :('
    end
  end
end

# This section is the entry point kind of like Main in cpp
game = Game.new
game.words = Game.read_words_from_file_if_exists

loop do
  system 'clear'
  game.gen_new_word
  game.play(10)
  print 'Do you want to play again? '
  play_again = gets.chomp.downcase.strip
  break if play_again != 'y'
end
