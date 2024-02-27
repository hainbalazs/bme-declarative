% list_increment(*L0, ?L): L is constructed by L0

list_increment([], []).
list_increment([A|L0], L) :-
  A1 is A+1,
  L = [A1|LH],
  list_increment(L0, LH).
