#!/usr/bin/env ruby
# frozen_string_literal:true

##########################################
# Semester 1 2019                        #
# Programming 4 Assignment 2 Master Mind #
# Trent Nicholson                        #
##########################################

# Constants for Game play
NUMBER_OF_ROUNDS = 10
WORD_FILE_LOCATION = 'mastermindWordList.txt'

class Word
  # Defines a static like method called valid to check if the word is valid in all respects of the game
  def self.valid(word)
    # Remove new line from end of word and change it to lowercase to avoid any issues with checking if the word contains no duplicates or incorrect characters
    word = word.chomp.downcase
    # Returns a check if the word is a valid length has no duplicates and is only composed of valid characters
    valid_length(word) && no_duplicates(word) && valid_characters_used(word)
  end

  # Defines a static like method called valid_length to check if word supplied to the function is a valid length
  def self.valid_length(word)
    # Checks if word supplied to the function is five characters long
    word.length == 5
  end

  # Defines a static like method called no_duplicates to check if the word has no duplicate letters
  def self.no_duplicates(word)
    # Iterates over the alphabet and checks if the current letter in the alphabet only occurs in the string once
    ('a'..'z').all? do |char| word.count(char) <= 1 end
  end

  # Defines a static like method called valid_characters_used to check if the word is composed only of valid characters
  def self.valid_characters_used(word)
    # Iterates over every character in the given word so I can test if the character is in the alphabet
    word.split('').each do |letter|
      # Returns false if the letter currently being evaluated is not in the alphabet
      return false unless ('a'..'z').include? letter
    end
    # Returns true if this method has not already returned
    true
  end
end

class Game
  attr_accessor :words

  def initialize
    @words = read_words_from_file_if_exists
  end

  def instructions
    puts 'Instructions:'
    puts '	The computer will generate a random word,'
    puts '	This word will be 5 letters long and consist of only unique letters'
    puts '	Your job is to guess what it is.'
    puts '	Feedback for your guesses are'
    puts '	? near'
    puts '	. miss'
  end

  def give_feedback(word)
    print 'Feedback: '
    word.chomp.chars.each_with_index do |char, index|
      if char == @current_word.chomp.chars[index]
        print @current_word.chomp.chars[index]
      elsif @current_word.chomp.include? char
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
  def read_words_from_file_if_exists
    if File.exist?(WORD_FILE_LOCATION)
      read_words_from_file
    else
      # Prints text to screen
      puts 'The mastermindWordList.txt was not found'
    end
  end

  def read_words_from_file
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
    gen_new_word
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

# This section is the entry point kind of like Main in CPP

# Create a new instance of game called new
game = Game.new
loop do
  system 'clear'
  game.play(NUMBER_OF_ROUNDS)
  print 'Do you want to play again? '
  play_again = gets.chomp.downcase.strip
  break if play_again != 'y'
end
