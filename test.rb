require 'minitest/autorun'

class String

  def num_occurrences_of(str, occurrences = 0)
    if include?(str)
      sub(str, '').num_occurrences_of str, occurrences + 1
    else
      occurrences
    end
  end

end

class StringTest < Minitest::Test

  def test_works
    str = "abbaaba"
    assert_equal 4, str.num_occurrences_of('a')
  end

  def test_works_with_no_occurences
    str = "abbaaba"
    assert_equal 0, str.num_occurrences_of('c')
  end

end
