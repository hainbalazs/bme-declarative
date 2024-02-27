defmodule Task4 do
  @spec all_different(xs::[any]) :: b::boolean
   # b igaz, ha az xs listában csupa különböző értékű elem van

  def all_different(xs) do
      !Enum.any?(for x <- xs, do: Enum.member?(xs--[x], x))
  end
end
