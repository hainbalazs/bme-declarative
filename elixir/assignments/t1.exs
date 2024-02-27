r1 = IO.inspect(Khf1.sit! 101)       === {0, []}
r2 = IO.inspect(Khf1.sit! 15)        === {5, [{3, [{1, 4}, {2, 3}, {3, 2}, {4, 1}]}, {5, [{1, 1}]}]}
r3 = IO.inspect(Khf1.sit! 14)        === {1, [{4, [{2, 1}]}]}
r4 = IO.inspect(Khf1.sit! 10)        === {1, [{4, [{1, 1}]}]}
r5 = IO.inspect(Khf1.sit! 9)         === {2, [{3, [{1, 2}, {2, 1}]}]}
r6 = IO.inspect(Khf1.sit! 5)         === {0, []}
r7 = IO.inspect(Khf1.good_flocks 20) === [6, 9, 10, 12, 14, 15, 16, 18, 20]

IO.puts "#{r1}, #{r2}, #{r3}, #{r4}, #{r5}, #{r6}, #{r7}"
