defmodule Khf3 do
  @moduledoc """
  Sátrak mátrixa
  @author "Hain Balázs Márk <hainb@edu.bme.hu>"
  @date   "2021-10-09"

  """

  @doc """
  The satrak_mx function produces a matrix of 0|1 describing the location of the tents.
  """
  @type parc_koord :: {i::integer, j::integer}    # {i,j} pair ({row,column}) specifying the location of a parcel.
  @type f_locations :: [parc_koord]               # List describing the location of a tree
  @type irany :: :N | :E | :S | :W                # North, south, east, west
  @type s_iranyok :: [irany]                      # List describing the direction of the tents associated with the trees
  @type s_matrix :: [[ 0 | 1 ]] | nil             # Matrix of tents: 1 = present, 0 = absent
  @type mx_res :: parc_koord | nil
  
  @spec all_different(xs::[any]) :: b::boolean
   # b is true if the list xs contains only elements with different values

  defp all_different(xs) do
      !Enum.any?(for x <- xs, do: Enum.member?(xs--[x], x))
  end

  @spec in_matrix(n::integer, m::integer, f::parc_koord, s::irany) :: r::mx_res
  defp in_matrix(n, m, {fy, fx}, s) do
    {fx2, fy2} = case s do
      :N ->
        {fx, fy - 1}
      :W ->
        {fx - 1, fy}
      :E ->
        {fx + 1, fy}
      :S ->
        {fx, fy + 1}
    end

    if fx < 1 or fy < 1 or fx > m or fy > n or fx2 < 1 or fy2 < 1 or fx2 > m or fy2 > n do
      :nil
    else
      {fy2, fx2}
    end
  end

  @spec satrak_mx(nm::parc_koord, fs::f_helyek, ss::s_iranyok) :: mss::s_matrix

  def satrak_mx({n, m}, fd, ss) do
    l = Enum.min([length(fd), length(ss)])
    input = (for i <- 0..l-1, pos = in_matrix(n, m, Enum.at(fd, i), Enum.at(ss, i)), pos != :nil, do: pos)
    if length(input) == l and all_different(input) do
      mx = (for _<-1..n, do: (for _<-1..m, do: 0))
      Enum.reduce(input, mx, fn {y,x}, acc -> List.replace_at(acc, y-1, List.replace_at(Enum.at(acc, y-1), x-1, 1)) end)
    else
      :nil
    end

  end

  end
