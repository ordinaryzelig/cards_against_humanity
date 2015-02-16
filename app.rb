# White cards
# Black cards
# Players
# Play

class String

  def num_occurrences_of(str, occurrences = 0)
    if self.include?(str)
      num_occurrences_of sub(str, ''), occurrences + 1
    else
      occurrences
    end
  end

end

module HasDescription

  def initialize(desc)
    @description = desc
  end

  def description
    @description
  end

  def to_s
    description
  end

end

class WhiteCard

  include HasDescription

end

class BlackCard

  BLANK = '%blank'

  include HasDescription

  def with(white_cards)
    filled_in = @description.dup
    white_cards.each do |white_card|
      filled_in.sub! BLANK, white_card.description
    end
    filled_in
  end

  def num_blanks
    description.num_occurrences_of(BLANK)
  end

end

class Play

  attr_accessor :black_card
  attr_reader :white_cards
  attr_reader :player

  def initialize(player)
    @player = player
    @white_cards = []
  end

  def to_s
    black_card.with(white_cards)
  end

end

class Round

  attr_reader :plays
  attr_reader :judge
  attr_reader :winning_play

  def initialize(judge)
    @plays = []
    @judge = judge
  end

  def run
    pick_winner
    award_point
    announce_winning_play
  end

private

  def pick_winner
    @winning_play = @judge.pick_winner(plays)
  end

  def award_point
    @winning_play.player.award_point(@winning_play.black_card)
  end

  def announce_winning_play
    puts "#{@winning_play.player} won with #{@winning_play.to_s.inspect} and now has a score of #{@winning_play.player.points}"
  end

end

class PlayerWon < StandardError
  def initialize(player)
    super "#{player.name} won!"
  end
end

class Player

  attr_reader :name
  alias_method :to_s, :name
  attr_reader :awarded_cards
  attr_reader :white_cards

  def initialize(name)
    @name = name
    @awarded_cards = []
    @white_cards = []
  end

  def pick_winner(plays)
    plays.sample
  end

  def award_point(black_card)
    awarded_cards << black_card
  end

  def points
    awarded_cards.size
  end

  def take_turn(black_card)
    play = Play.new(self)
    play.black_card = black_card
    played_white_cards =
      black_card.num_blanks.times.map do
        @white_cards.pop
      end
    play.white_cards = played_white_cards
    play
  end

end

class Game

  attr_reader :rounds

  def initialize(players, white_cards, black_cards)
    @rounds = []
    @players = players
    @white_cards = white_cards.shuffle
    @black_cards = black_cards.shuffle
    deal_cards
  end

  def simulate
    loop do
      begin
        play_round
      rescue PlayerWon => ex
        puts ex.message
        break
      end
    end
  end

private

  def play_round
    judge = @players.sample
    round = Round.new(judge)
    black_card = @black_cards.pop
    remaining_players = @players - [judge]
    remaining_players.each do |player|
      round.plays << player.take_turn(black_card)
    end
  end

  def deal_cards
    @players.each do |player|
      player.white_cards.push *@white_cards.take(10)
    end
  end

end

players = 3.times.map do |idx|
  Player.new("Player #{idx + 1}")
end
judge = Player.new("judge")

black_cards =
  [
    '%blank: kid tested, mother approved',
    '%blank: good to the last drop',
    'Lifetime presents %blank, the Story of %blank',
  ].map do |desc|
    BlackCard.new(desc)
  end

white_cards =
  3.times.map do |idx|
    WhiteCard.new("Description #{idx}")
  end

#round = Round.new(judge)

#players.each do |player|
  #play = Play.new(player)
  #play.black_card = black_card
  #play.white_cards.push white_cards.pop
  #round.plays << play
#end

#round.plays.each do |play|
  #puts play
#end

game = Game.new(players, white_cards, black_cards)
game.simulate
