has_1len_sublist(L):-
  findall(Sl, (member(Li, L), length(Li, 1)), Sls),
  \+ length(Sls, 0).
