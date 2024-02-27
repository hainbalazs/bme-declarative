defmodule Task1 do

  @spec prime?(k::integer) :: b::boolean
  def prime?(2), do: :true
  def prime?(k) do
      sqrt = :math.sqrt(k)
      sqrt_int = trunc(Float.ceil(sqrt))

      range = 2 .. sqrt_int
      !Enum.any?(for x <- range, rem(k, x) == 0, do: x)
  end


  @spec osszetett(k::integer) :: xs::[integer]

  def osszetett(k) do
      ls = 4..k*k
      for x <- ls, !prime?(x), do: x
  end

  @spec primek(k::integer) :: xs::[integer]

  def primek(k) do
      ls = 2..k*k
      for x <- ls, prime?(x), do: x
  end

end
