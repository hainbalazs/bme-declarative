:- use_module(library(lists)).

test(A, L):-
  findall(N, (
    member(T, A),
    findall(TO, (member(TO, A), TO \= T, TS is T+TO, 1 is mod(TS, 2)), N),
    length(N, Nc),
    Nc > 0
  ), L).



  % [sor(1,1),sor(2,1),sor(1,1),sor(2,1),sor(3,0),sor(5,0),sor(4,3),sor(3,0),sor(5,0),oszl(1,1),oszl(2,0),oszl(3,2),oszl(4,0),oszl(5,2)].
  %solve(5-5,
  %[1-2,3-3,3-5,5-1,5-5],
  %[sor(1,1),sor(2,1),sor(1,1),sor(2,1),sor(3,0),sor(5,0),sor(4,3),sor(3,0),sor(5,0),oszl(1,1),oszl(2,0),oszl(3,2),oszl(4,0),oszl(5,2)],
  %[[e,s,w],[e,n,s,w],[n,s,w],[e,n],[n,w]], ILs).

  %Elvégzi a feladatban előírt sátorszűkítést
  sator_szukites(_, _, [], ILs) :- !, ILs = [].
  sator_szukites(_, I, ILs0, ILs) :-
    nth1(I, ILs0, Ds),
    length(Ds, DL),
    DL > 1, !,
    ILs = ILs0.
  sator_szukites(Fs, I, ILs0, ILs) :-
    zip(Fs, ILs0, FDs),
    nth1(I, FDs, F-[D]),
    calc_coord(F, D, Ts),
    find_neighbours(Ts, Ns),

    findall(Fi-Cs, (member(Fi-Di, FDs),
                findall(Dii-Ci, (member(Dii, Di), calc_coord(F, Dii, Ci)), Cs)),
            FCs),


    findall(DLi2,
      (member(Fi2-Ci2, FCs),
       findall(Dii2, (member(Dii2-Cii2, Ci2), (Fi2 \= F ->  \+ member(Cii2, Ns); true)),
       DLi2)),
    Res),
    (member([], Res) -> ILs = [];
    ILs = Res).
