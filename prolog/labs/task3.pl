power(_A, 0, 1).
power(A, E, H):-
  E > 0,
  E1 is E-1,
  power(A, E1, H1),
  H is A * H1.
