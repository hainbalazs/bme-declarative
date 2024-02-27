(puzzle1 = Nhf1.to_internal "nhf1_f1.txt") |> IO.inspect
IO.puts "---"
(puzzle2 = Nhf1.to_internal "nhf1_f2.txt") |> IO.inspect
IO.puts "---"

(Nhf1.to_external puzzle1, [], "r1.txt")                  |> IO.inspect
IO.puts "---"
(Nhf1.to_external puzzle1, [:E,:S,:N,:N,:N], "r2.txt")    |> IO.inspect
IO.puts "---"
(Nhf1.to_external puzzle2, [:E,:S,:N,:N,:W,:E], "r3.txt") |> IO.inspect
IO.puts "---"

(Nhf1.check_sol puzzle1, [:E,:S,:N,:N,:N])     |> IO.inspect
IO.puts "---"
(Nhf1.check_sol puzzle1, [:E,:S,:N,:N,:N, :E]) |> IO.inspect
IO.puts "---"
(Nhf1.check_sol puzzle2, [:E,:S,:N,:N,:W, :E]) |> IO.inspect
IO.puts "---"
