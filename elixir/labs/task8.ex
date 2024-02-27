defmodule Task8 do
  @spec kozepe(mss::[[any]]) :: rss::[[any]]
   # rss az mss n*n-es négyzetes mátrix olyan (n/2)*(n/2) méretű részmátrixa,
   # mely az n/4+1. sor n/4+1. oszlopának elemétől kezdődik
   # négyzetes az olyan mátrix, amelynek n sora és n oszlopa van, ahol
   # az n>=4 páros négyzetszám
   def kozepe(mss) do
     str_i = div(Enum.count(mss), 4)
     len = div(Enum.count(mss), 2)
     Enum.map(Enum.slice(mss, str_i, len), fn x ->
       Enum.slice(x, str_i, len)
     end)
   end

   @spec laposkozepe(mss::[[any]]) :: xs::[any]
   # Az xs lista az mss mátrix középső elemeinek listája
   def laposkozepe(mss), do: List.flatten(kozepe(mss))


end
