defmodule Task7 do
 @type mx :: rs::[cs::[integer]]
 @spec negyzetes(k::integer) :: mss::mx
 # k^2 méretű mátrixok olyan k^4 méretű mátrixa mss, amelyben
 # az elemek értéke 1-től k^4-ig minden sorban felülről lefelé
 # haladva egyesével nő: a bal felső (1,1) indexű elem értéke 1,
 # alatta az (1,0) indexűé 2 stb., a (k^2,k^k) indexűé pedig k^4

 def negyzetes(k) do
   for x <- 1..k*k, do: (for y <- 0..k*k-1, do: x+(y*k*k))
 end

 @spec matrix_ki(mss::mx) :: :ok
 # a negyzetes/1 függvény által előállított mátrix kiírása a
 # képernyőre úgy, hogy a mátrix minden sora új sorba kerüljön,
 # a számok pedig oszloponként balra legyenek illesztve, a
 # vezető 0-k helyén szóközzel

  def matrix_ki(mss) do
   maxlen = 1 + String.length(Integer.to_string(Enum.at(Enum.at(mss,-1),-1)))
   Enum.each(mss, fn x ->
     Enum.each(x, fn y ->
       IO.write(String.pad_leading(Integer.to_string(y), maxlen))
     end); IO.write("\n")
   end)
  end

end
