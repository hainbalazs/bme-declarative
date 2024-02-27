defmodule Task11 do
  @spec transpose(mss::[[any]]) :: tss::[[any]]
 # az mss valódi mátrix transzpontáltja tss

  def transpose(mss), do: Enum.unzip(mss)
end
