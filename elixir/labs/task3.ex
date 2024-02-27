defmodule Task3 do
  @spec duplak(xs::[any]) :: ys::[any]

  def duplak(xs) do
      [_|xs_1] = xs
      for {a,b} <- Enum.zip(xs, xs_1), a == b, do: a
  end
end
