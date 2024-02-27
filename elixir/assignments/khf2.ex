defmodule Khf2 do

  @moduledoc """
  Szövegelő
  @author "Hain Balázs Márk <hainb@edu.bme.hu>"
  @date   "2021-10-02"
  ...
  """

  @doc """
  The szovegelo function creates a 2D array,
  by first creating lines (the scanned file is split into "\n"
  - discarding empty lines), then produces a list of words from the lines,
  (also splitting along whitespaces - empty words are discarded).
  Let m be the longest word list representing such a row. From each such list
  element i is retrieved (0<=i<=m), if i >= length of the list under test, :nil
  is used. 
  """
  @spec szovegelo(file :: String.t) :: rss:: [[String.t | nil]]
  # Generates the rss text matrix from the file contents.
  # The scanned text and the text matrix have the same number of lines.
  # The number of columns in the text matrix is equal to the longest
  # number of words in the longest line. In each cell of the matrix, the
  # file or the nil atom. The words are separated by one or
  # more space-like characters. The rows from left to right are
  # words are inserted from left to right, with a blank at the end of each line
  # and the nil atom in the cells that remain empty.

  def szovegelo(file) do
    {_, f} = File.read(file)
    rows = String.split(f, "\n", trim: true)
    m = Enum.max(for row <- rows, do: length(String.split(row))) - 1

    (for row <- rows, m >= 0,  rs = String.split(row), rs != [], do: for i <- 0..m, do: Enum.at(rs, i))

  end


end
