defmodule Nhf1 do

  @moduledoc """
  Sátrak
  @author "Hain Balázs Márk <hainb@edu.bme.hu>"
  @date   "2021-10-16"
  ...
  """

  @doc """
  ...
  """
  @type row :: integer # number of rows (1 to n)
  @type col :: integer # column number (1 to m)
  @type field :: {row, col} # coordinates of a parcel

  @type tentsCountRows :: [integer] # number of tents per row
  @type tentsCountCols :: [integer] # number of tents per column

  @type trees :: [field] # coordinates of the parcels containing trees
  @type puzzle_desc :: {tentsCountRows, tentsCountCols, trees} # the puzzle descriptor triples

  @type dir :: :N | :E | :S | :W # direction of the tent positioning arrows: North, East, South, West
  @type tent_dirs :: [dir] # list of directions of tent positions relative to trees

  @type cnt_tree :: integer # the number of trees in the garden
  @type cnt_tent :: integer # number of tents in the garden
  @type err_diff :: %{err_diff: [{cnt_tree, cnt_tent}]} # different number of tents and trees
  @type err_rows :: %{err_rows: [integer]}              # the number of tents is wrong in the listed rows
  @type err_cols :: %{err_cols: [integer]}              # the number of tents is wrong in the listed columns
  @type err_touch :: %{err_touch: [field]}                # tents with listed coordinates are touching each other
  @type errs_desc :: {err_diff, err_rows, err_cols, err_touch} # error descriptor quad

  @doc """
  ...
  """
  @spec to_internal(file::String.t) :: pd::puzzle_desc
  # Descriptor of the puzzle represented in text in the file pd

  def to_internal(file) do
    {_, f} = File.read(file)
    rows = String.split(f, "\n", trim: true)
    #m = Enum.max(for row <- rows, do: length(String.split(row))) - 1

    tentsCountCols = (for e <- String.split(Enum.at(rows, 0)), do: String.to_integer(e))
    tentsCountRows = (for row <- Enum.drop(rows, 1), do: String.to_integer(Enum.at(String.split(row), 0)))
    trees = (for i <- 1..Enum.count(rows)-1, row = String.split(Enum.at(rows, i)), j <- 1..Enum.count(row)-1, Enum.at(row, j) == "*", do: {i, j})


    {tentsCountRows, tentsCountCols, trees}
  end

  @doc """
  ...
  """
  @spec to_external(pd::puzzle_desc, ds::tent_dirs, file::String.t) :: :ok
  # Based on the {rs, cs, ts} = pd task descriptor and the ds tent direction list
  # writes the textual representation of the task to the file file where
  # rs is the list of the expected number of tents per line,
  # cs is the list of the expected number of tents per column,
  # ts is the list of coordinates of the parcels containing trees

  def to_external(pd, ds, file) do
    {rs, cs, ts} = pd
    p_size_c = padding_size(cs)
    p_size_r = padding_size(rs)
    tents = tent_map(ts, ds)
    n = Enum.count(rs)
    m = Enum.count(cs)

    mx = [[" "] ++ (for c <- cs, do: Integer.to_string(c))] ++  \
    (for i <- 1..n, do: [String.pad_leading(Integer.to_string(Enum.at(rs, i-1)), p_size_r)] ++ \
    (for j <- 1..m do
       cond do
         Enum.member?(ts, {i, j}) -> "*"
         Map.has_key?(tents, {i, j}) -> Atom.to_string(Map.fetch!(tents, {i, j}))
         true -> "-"
       end
     end)
    )

    File.write(file, "", [:write])
    Enum.each(mx, fn x ->
      Enum.each(x, fn y ->
        File.write(file, String.pad_leading(y, p_size_c), [:append]);
        File.write(file, " ", [:append])
      end); File.write(file, "\n", [:append])
    end)

    :ok
  end

  defp padding_size(cols) do
    min = if Enum.min(cols) < 0, do: trunc(:math.log10(abs(Enum.min(cols)))+1)+1, else: 0
    max = if Enum.max(cols) != 0, do: trunc(:math.log10(Enum.max(cols))+1), else: 0

    Enum.max([min, max])
  end

  def tent_map(ts, ds) do
    (for zz<-Enum.zip(ts, ds), {t, d} = zz, into: %{} do
      {fy, fx} = t

      {fx2, fy2} = case d do
        :N ->
          {fx, fy - 1}
        :W ->
          {fx - 1, fy}
        :E ->
          {fx + 1, fy}
        :S ->
          {fx, fy + 1}
        end

        {{fy2, fx2}, d}
    end)

    end

  @doc """
  ...
  """
  @spec check_sol(pd::puzzle_desc, ds::tent_dirs) :: ed::errs_desc
  # The {rs, cs, ts} = pd task descriptor and the ds tent direction list
  # the result of the check is the error descriptor cd, where
  # rs is the list of the expected number of tents per line,
  # cs is the list of the expected number of tents per column,
  # ts is the list of coordinates of the parcels containing trees
  # The elements of the quad {e_diff, e_rows, e_cols, e_touch} = ed are
  # key-value pairs in which the key refers to the nature of the error
  # value is the list of fault locations (empty if no fault)

  def check_sol(pd, ds) do
    {rs, cs, ts} = pd
    n = Enum.count(rs)
    m = Enum.count(cs)
    tents = Enum.filter(Map.keys(tent_map(ts, ds)), fn {y, x} -> x > 0 and y > 0 and x <= m and y <= n end)
    ts_c = Enum.count(ts)
    ts_c_in = Enum.count(tents)
    ds_c = Enum.count(ds)


    e_diff = if ts_c != ds_c, do: [{ts_c, ds_c}], else: []
    e_rows = (for i <- 1..n, ix = Enum.at(rs, i-1), ix >= 0, Enum.count(Enum.filter(tents, &match?({^i, _}, &1))) != Enum.at(rs, i-1), do: i)
    e_cols = (for i <- 1..m, ix = Enum.at(cs, i-1), ix >= 0, Enum.count(Enum.filter(tents, &match?({_, ^i}, &1))) != Enum.at(cs, i-1), do: i)
    e_touch = Enum.sort(Enum.uniq(List.flatten(for i<-0..ts_c_in-2, do: for j<-i+1..ts_c_in-1, is_neighbour?(Enum.at(tents, i), Enum.at(tents, j)), do: [Enum.at(tents, i), Enum.at(tents, j)])))


    {%{err_diff: e_diff}, %{err_rows: e_rows}, %{err_cols: e_cols}, %{err_touch: e_touch}}
  end

  defp is_neighbour?(t1, t2) do
    {y1, x1} = t1
    {y2, x2} = t2
    abs(x1-x2) < 2 and abs(y1-y2) < 2
  end

end
