% list_length(*List, -Len): The length of the list is Len.
list_length([], 0).
list_length([LX|LY], H) :-
  list_length(LY, H0),
  H is H0+1.
