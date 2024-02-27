% :- type parcMutató ==   int-int.          % egy parcella helyét meghatározó egészszám-pár
% :- type fák        ==   list(parcMutató). % a fák helyeit tartalmazó lista
% :- type irány    --->   n                 % észak
%                       ; e                 % kelet
%                       ; s                 % dél
%                       ; w.                % nyugat
% :- type sHelyek    ==   list(irany).      % a fákhoz tartozó sátrak irányát megadó lista
% :- type bool       ==   int               % csak 0 vagy 1 lehet
% :- type boolMx     ==   list(list(bool)). % a sátrak helyét leíró 0-1 mátrix

% :- pred satrak_mx(parcMutató::in,         % NM
%                   fák::in,                % Fs
%                   sHelyek::in,            % Ss
%                   boolMx::out).           % Mx

% fő feladat megoldása, elő állítja -Mx -ben a sátrak mátrixát
satrak_mx(NM, Fs, Ss, Mx):-
  N-M = NM,
  create_tents(N-M, Fs, Ss, Tents),
  all_different(Fs),
  all_different(Tents),
  all_in_matrix(N-M, Fs),
  all_in_matrix(N-M, Tents),
  create_mx(N-M, 0, Tents, Mx).

% Ellenőrzi, hogy Co lista elemei mind különbözőek-e
all_different(Co):-
    all_different_s(Co, []).

% all_different segédfüggvénye
all_different_s([], _L).
all_different_s(Co, L):-
    [CH|CT] = Co,
    append(CT, L, CRest1),
    \+ member(CH, CRest1),
    append([CH], L, CRest2),
    all_different_s(CT, CRest2).

% Ellenőrzi, hogy {Cy, Cx} koordinátával jellemzett pont az N*M mátrixon belüli-e
in_matrix(N-M, Cy-Cx):-
  0 < Cx, 0 < Cy,
  Cy =< N, Cx =< M.

% Ellenőrzi, hogy egy adott lista pontjai mind a mátrixon belüliek-e
all_in_matrix(N-M, []).
all_in_matrix(N-M, [CH|CT]):-
  in_matrix(N-M, CH),
  all_in_matrix(N-M, CT).

% Kiszámolja a fa pozíciójából, és a sátor relatív helyzetéből a sátor pozícióját
create_tent(N-M, Cy-Cx, Dir, T):-
    (Dir = n ->  CyR is Cy-1, CxR is Cx
    ;
    Dir = s ->  CyR is Cy+1, CxR is Cx
    ;
    Dir = w ->  CyR is Cy, CxR is Cx-1
    ;
    CyR is Cy, CxR is Cx+1
    ),
    T = CyR-CxR.

% Kiszámolja a k db fa pozíciójából, és a sátorhoz való relatív helyzetéből k db sátor pozícióját
create_tents(N-M, [], [], []).
create_tents(N-M, [CH|CT], [DH|DT], [TH|TT]):-
    create_tent(N-M, CH, DH, TH),
    create_tents(N-M, CT, DT, TT).

% Elkészíti a kért mátrixot a sátor abszolútpozíció lista alapján
create_mx(N-M, N, _, []).
create_mx(N-M, I, Ts, [MxH|MxT]):-
  N > I,
  I1 is I+1,
  create_row(I1-M, 0, Ts, MxH),
  create_mx(N-M, I1, Ts, MxT).

% Elkészíti a kért mátrix I. sorát a sátor abszolútpozíció lista alapján
create_row(I-M, M, _, []).
create_row(I-M, J, Ts, [RH|RT]):-
    M > J,
    J1 is J+1,
    (member(I-J1, Ts) -> RH is 1;
    RH is 0
    ),
    create_row(I-M, J1, Ts, RT).
