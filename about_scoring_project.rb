require File.expand_path(File.dirname(__FILE__) + '/edgecase')

# Greed is a dice game where you roll up to five dice to accumulate
# points.  The following "score" function will be used to calculate the
# score of a single roll of the dice.
#
# A greed roll is scored as follows:
#
# * A set of three ones is 1000 points
#
# * A set of three numbers (other than ones) is worth 100 times the
#   number. (e.g. three fives is 500 points).
#
# * A one (that is not part of a set of three) is worth 100 points.
#
# * A five (that is not part of a set of three) is worth 50 points.
#
# * Everything else is worth 0 points.
#
#
# Examples:
#
# score([1,1,1,5,1]) => 1150 points
# score([2,3,4,6,2]) => 0 points
# score([3,4,5,3,3]) => 350 points
# score([1,5,1,2,4]) => 250 points
#
# More scoring examples are given in the tests below:
#
# Your goal is to write the score method.

def score(dice)
  # You need to write this method
  points = 0
  triples = []        #stores triples of any number
  non_triples = []    #stores remaining rolls
  num_limit = 3       #allows one triple (change to 6 to allow two triples, 9 to allow three triples, etc.)

  #Split into triple rolls and non-triple rolls
  while dice.empty? == false do
    if dice.count(dice.last) >= num_limit && (triples.empty? || dice.last == triples.last)
      triples.push(dice.last)
      num_limit -= 1
      if triples.size == 3 #Triple caught
        num_limit = 100 #Set num_limit to arbitrary large number to prevent
                        #other rolls from being counted towards the triple
      end
    else
      non_triples.push(dice.last)
    end
    dice.pop
  end

  #Allocate points for non-triples
  while non_triples.empty? == false do
    if non_triples.last == 1
      points += 100
    elsif non_triples.last == 5
      points += 50
    end
    non_triples.pop
  end

  #Allocate points for triples
    if triples.size == 3
    case triples[0]
      when 1
        points += 1000
      when 2..6
        points += triples[0]*100
      else
        raise TriplesError, "Something messed up with the triples"
    end
  end
  triples.clear

  #Return total points
  points

end

class TriplesError < StandardError
end

class AboutScoringProject < EdgeCase::Koan
  def test_score_of_an_empty_list_is_zero
    assert_equal 0, score([])
  end

  def test_score_of_a_single_roll_of_5_is_50
    assert_equal 50, score([5])
  end

  def test_score_of_a_single_roll_of_1_is_100
    assert_equal 100, score([1])
  end

  def test_score_of_multiple_1s_and_5s_is_the_sum_of_individual_scores
    assert_equal 300, score([1,5,5,1])
  end

  def test_score_of_single_2s_3s_4s_and_6s_are_zero
    assert_equal 0, score([2,3,4,6])
  end

  def test_score_of_a_triple_1_is_1000
    assert_equal 1000, score([1,1,1])
  end

  def test_score_of_other_triples_is_100x
    assert_equal 200, score([2,2,2])
    assert_equal 300, score([3,3,3])
    assert_equal 400, score([4,4,4])
    assert_equal 500, score([5,5,5])
    assert_equal 600, score([6,6,6])
  end

  def test_score_of_mixed_is_sum
    assert_equal 250, score([2,5,2,2,3])
    assert_equal 550, score([5,5,5,5])
  end

end
