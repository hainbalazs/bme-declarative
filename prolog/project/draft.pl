get_shortest_sublist(L, R):-
  aggregate(min(C,E),(member(E,L),length(E,C), C > 1),min(_,S)),
  nth1(I, L, S), !,
  select(S, L, R2), !,
  member(El, S),

el_idx(L, R):-
  el_idx_s(L, 0, R).

el_idx_s([], _, []).
el_idx_s([LH|LT], N, [RH|RT]):-
  RH = LH-N,
  N1 is N+1,
  el_idx_s(LT, N1, RT).
