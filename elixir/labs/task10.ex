defmodule Task10 do

  @spec pivot(mss::[[any]],r::integer,c::integer) :: rss::[[any]]
  def pivot(mss, r, c) do
    l = Enum.to_list(0..Enum.count(mss)-1)
    oszlop = l--[c]
    sor = l--[r]
    Enum.map(sor, fn y ->
      Enum.map(oszlop, fn x  ->
        Enum.at(Enum.at(mss, y), x)
      end)
    end)
  end


end
