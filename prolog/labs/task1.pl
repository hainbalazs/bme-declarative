seq(N, M, []) :-
 M =:= N - 1.
seq(N, M, [N|Seq]) :-
 M >= N,
 N1 is N+1,
 seq(N1, M, Seq).
