% list_last_item(*L, ?Value): Last element of the list --> Value.

list_last_item([A|[]], A).
list_last_item([_|L2], E):-
  list_last_item(L2, E).
