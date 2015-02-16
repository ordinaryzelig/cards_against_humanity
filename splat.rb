def add(n1, n2, *more_nums)
  sum = n1 + n2
  sum += more_nums.reduce(0, :+)
  puts sum
end

[
  [1, 2],
  [3, 4],
  [9, 2],
  [9, 2, 3, 4],
].each do |nums|
  add *nums
end
