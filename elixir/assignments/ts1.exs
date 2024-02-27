defmodule Khf1.CheckAnswer do
  
  @moduledoc """
  Szkript a Khf1.sit! függvény visszatérési értéke strukturális
  helyességének ellenőrzésére

  @author "hanak@emt.bme.hu"
  @date   "$LastChangedDate: 2021-09-26 10:01:52 +0200 (Sun, 26 Sep 2021) $$"
  """

def go answer do
    cond do
      not is_tuple(answer) ->
	"A válasz nem ennes, hiba."
      not is_integer(elem answer, 0) ->
	"A pár első tagja nem egész (ültetések száma), hiba."
      not is_list(elem answer, 1) ->
	"A pár második tagja nem lista (ültetések listája), hiba."
      not Enum.all? (elem answer, 1), &is_tuple/1 ->
	"Az ültetési lista elemei nem ennesek, hiba."
      not Enum.all? (elem answer, 1), &((tuple_size &1) === 2) ->
	"Az ültetési lista elemei nem párok, hiba."
      not Enum.all? (for {n, _ls} <- (elem answer, 1), do: is_integer n) ->
	"Az ültetési lista elemeinek első tagja nem egész (ültetési sorok száma), hiba."
      not Enum.all? (for {_n, ls} <- (elem answer, 1), do: is_list ls) ->
	"Az ültetési lista elemeinek második tagja nem lista (ültetések leírása), hiba."
      not Enum.all? (for {_n, ls} <- (elem answer, 1), p <- ls, do: (is_tuple p) and ((tuple_size p) === 2)) ->
	"Az ültetések leírása nem pár ({hátsó sor hossza, sorok különbsége}) az ültetési listákban."
      true ->
	"A válasz struktúrája helyes. Azt nem ellenőriztem, hogy az ültetési leírásokban a párok egészpárok-e."
    end
  end
end
