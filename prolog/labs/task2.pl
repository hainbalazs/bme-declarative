max(N, N) :-
 N > 0.
max(N, X) :-
 N > 1,
 N1 is N-1,
 max(N1, X).
