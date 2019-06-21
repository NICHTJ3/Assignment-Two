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

# This class is a utilities class for checking if a word is valid all functions
# are accessed like static functions ie Word.function_name
class Word
  # Defines a static like method called valid to check if the word is valid in
  # all respects of the game
  def self.valid(word)
    # Remove new line from end of word and change it to lowercase to avoid any
    # issues with checking if the word contains no duplicates or incorrect
    # characters
    word = word.chomp.downcase
    # Returns a check if the word is a valid length has no duplicates and is
    # only composed of valid characters
    valid_length(word) && no_duplicates(word) && valid_characters_used(word)
  end

  # Defines a static like method called valid_length to check if word supplied
  # to the function is a valid length
  def self.valid_length(word)
    # Checks if word supplied to the function is five characters long
    word.length == 5
  end

  # Defines a static like method called no_duplicates to check if the word has
  # no duplicate letters
  def self.no_duplicates(word)
    # Iterates over the alphabet and checks if the current letter in the
    # alphabet only occurs in the string once or less times
    ('a'..'z').all? { |char| word.count(char) <= 1 }
  end

  # Defines a static like method called valid_characters_used to check if the
  # word is composed only of valid characters
  def self.valid_characters_used(word)
    # Iterates over every character in the given word so I can test if the
    # character is in the alphabet
    word.split('').each do |letter|
      # Returns false if the letter currently being evaluated is not in the
      # alphabet
      return false unless ('a'..'z').include? letter
    end
    # Returns true if this method has not already returned
    true
  end
end

# This class is the game class it contains all methods required to run the game
class Game
  # The constructor like method for game that is called when a new game is
  # created
  def initialize
    # Set the private variable words to the valid words from the text file if it
    # exists
    @words = read_words_from_file_if_exists
  end

  # Print the instructions for the game to the console with new lines between
  # each
  def instructions
    puts 'Instructions:'
    puts '	The computer will generate a random word,'
    puts '	This word will be 5 letters long and consist of only unique letters'
    puts '	Your job is to guess what it is.'
    puts '	Feedback for your guesses are'
    puts '	? near'
    puts '	. miss'
  end

  # Give the user feedback by either printing the letter at that possition in
  # the word if it was correct or a . if it wasn't in the word or a ? if it was
  # in the word but not at that spot
  def give_feedback(guess)
    # Prints feedback: without a new line so i can add the users feedback to
    # the same line
    print 'Feedback: '
    # Removes the space from the users guess and itterates over its characters
    # with an index so i can check if the character in the current word is the
    # same or not
    guess.chomp.chars.each_with_index do |char, index|
      # Checks if the character in the users guess is the same as the character
      # in the current_word
      if char == @current_word.chomp.chars[index]
        print @current_word.chomp.chars[index]
      # Prints a question mark if the character in the users guess is not the
      # same as the character at the current index in the current word but is
      # in the word without a new line
      elsif @current_word.chomp.include? char
        print '?'
      # Prints a . if the character in the users guess was not in the current
      # word without a new line
      else
        print '.'
      end
    end
    # Prints a new line below the feedback
    puts
  end

  # Checks if the users guess is the same as the current_word
  def check_word_is_correct(guess)
    # Checks if the users guess is the same as the current_word and returns a
    # boolean
    guess == @current_word
  end

  # Sets the current word to a random word that has been read from the
  # mastermindWordList.txt file
  def gen_new_word
    # Picks a random word from the list and sets the current_word to that word
    @current_word = @words[rand(@words.count)]
  end

  # Reads the words from the mastermindWordList.txt file if it exists
  def read_words_from_file_if_exists
    # Reads the valid words from the file if the file exists
    if File.exist?(WORD_FILE_LOCATION)
      read_words_from_file
    else
      # Prints text to screen with a new line at the end
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

  # Tells the player how to play and asks the player to guess the current word,
  # Gives them feedback and asks them again if they haven't run out of guesses
  # or guessed it
  def play(num_of_rounds)
    # Pick a new current word for the current game
    gen_new_word
    # Assign the variable correct a default value of false
    correct = false
    # Set the number of guesses the user has taken to zero by default
    guesses = 0
    # Print the instructions for the game
    instructions
    # Keep asking the player for a guess while they haven't guessed it and they
    # haven't run out of guesses
    until guesses == num_of_rounds || correct
      # Print how many guesses the user has left with a new line at the end
      puts "You have #{num_of_rounds - guesses} guesses left"
      # Print 'Guess:' without a new line
      print 'Guess:    '
      # Get and store the players input in lowercase with no spaces first it
      # converts it to a string to avoid enter breaking the game
      guess = gets.to_s.chomp.downcase.strip
      # Tell the user there input was invalid if their input was invalid
      if !Word.valid(guess)
        puts 'Invalid input. Guesses must be 5 characters long and contain no
        duplicate letters or symbols'
      # Otherwise give them feedback on there guess and check if it was correct
      else
        # Add 1 to the number of guesses the user has taken so i can stop the
        # loop if they exceed the number of guesses allowed
        guesses += 1
        # Print feedback on the screen for the users current guess
        give_feedback(guess)
        # Assign the correct variable the boolean returned from the
        # check_word_is_correct method this is so i can stop the game looping
        # if they guessed the word
        correct = check_word_is_correct(guess)
      end
    end
    # Print a message saying congratulations if the user guessed it or better
    # luck next time if they ran out of guesses
    if correct
      # Print with a new line at the end
      puts 'Congratulations you guessed it :)'
    else
      # Print with a new line at the end
      puts 'Better luck next time :('
    end
  end
end

# This section is the entry point kind of like Main in CPP

# Create a new instance of game called new that will read in the words and
# assign its current_word for the first game loop
game = Game.new
# Loop continuously until the user decides to stop playing when i ask them if
# they want to play again
loop do
  # Clear the cmd prompt so the user doesn't get overwhelmed
  system 'clear'
  # Call the play game method on the instance of game
  game.play(NUMBER_OF_ROUNDS)
  # Ask if the user wants to play again so i can receive there input below
  print 'Do you want to play again? Y/N:'
  # Convert the users input to a lowercase string with no spaces or newlines so
  # i can compare it to the expected input in lowercase
  play_again = gets.chomp.downcase.strip
  # Break from the loop to stop the game playing if the user doesn't input a y
  # above
  break if play_again != 'y'
end
