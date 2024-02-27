:- use_module(library(lists)).
:- use_module(library(between)).


% :- type parcMutató ==    int-int.          % egy parcella helyét meghatározó egészszám-pár
% :- type fák ==           list(parcMutató). % a fák helyeit tartalmazó lista
% :- type irány    --->    n                 % észak
%                        ; e                 % kelet
%                        ; s                 % dél
%                        ; w.                % nyugat
% :- type iránylista ==    list(irany).      % egy adott fához rendelt sátor
                                             % lehetséges irányait megadó lista
% :- type iránylisták ==   list(iránylista). % az összes fa iránylistája

% :- pred iranylistak(parcMutató::in         % NM
%                     fák::in,               % Fs
%                     iránylisták::out)      % ILs

% :- pred sator_szukites(fák::in,            % Fs
%                        int::in,            % I
%                        iránylisták::in,    % ILs0
%                        iránylisták::out)   % ILs

% Előállítja az összes Fs-beli fához tartozó iránylistát, vagy []-t ha nem létezik mo.
iranylistak(NM, Fs, ILs)  :-
  findall(Dir, (member(F, Fs), iranylista(NM, Fs, F, Dir), length(Dir, DirC), DirC > 0), Res),
  (length(Res, L), length(Fs, L) -> ILs = Res;
  ILs = []).

% Előállítja az F = Fy-Fx koordináta által jelzett fához tartozó iránylistát (Dir) az N*M-es mátrixon belül
% Dir = {d | P = F és d által kijelölt pont, P a mátrixon belüli, P != Fi € Fs}
iranylista(NM, Fs, Fy-Fx, Dir):-
  Fpx is Fx+1, Fmx is Fx-1, Fpy is Fy+1, Fmy is Fy-1,
  Fn = [Fy-Fpx-e, Fy-Fmx-w, Fpy-Fx-s, Fmy-Fx-n],
  findall(D, (member(Y-X-D, Fn), in_matrix(NM, Y-X), \+ member(Y-X, Fs)), Dl),
  sort(Dl, Dir).

% Ellenőrzi, hogy {Cy, Cx} koordinátával jellemzett pont az N*M mátrixon belüli-e
in_matrix(N-M, Cy-Cx):-
  0 < Cx, 0 < Cy,
  Cy =< N, Cx =< M.

%Elvégzi a feladatban előírt sátorszűkítést
sator_szukites(Fs, I, ILs0, ILs) :-
  nth1_sajat(I, ILs0, [D]),
  nth1_sajat(I, Fs, F),
  calc_coord(F, D, Ts),
  find_neighbours(Ts, Ns),
  zip(Fs, ILs0, FDs),
  findall(DLi2,
    (member(Fi-DLi, FDs),
     findall(Di, (member(Di, DLi), calc_coord(Fi, Di, Ci), (Fi \= F ->  \+ member(Ci, Ns); true)),
     DLi2)),
  Res),
  (member([], Res) -> ILs = [];
  ILs = Res).

% Ns lista tartalmazza az Fy-Fy koordinátát és az általa kijelölt parcella sarok és oldalszomszédjainak a koordinátáit.
find_neighbours(Fy-Fx, Ns):-
  Fpx is Fx+1, Fmx is Fx-1, Fpy is Fy+1, Fmy is Fy-1,
  findall(Y-X, (between(Fmy, Fpy, Y), between(Fmx, Fpx, X)), Ns).

% Kiszámolja a fa pozíciójából, és a sátor relatív helyzetéből a sátor pozícióját
calc_coord(Cy-Cx, D, T):-
  (D = n ->  CyR is Cy-1, CxR is Cx
  ;
  D = s ->  CyR is Cy+1, CxR is Cx
  ;
  D = w ->  CyR is Cy, CxR is Cx-1
  ;
  CyR is Cy, CxR is Cx+1
  ),
  T = CyR-CxR.

% Két listát összefűz, úgy hogy elemei az eredeti két lista által alkotott Ai-Bi pár
zip([], [], []).
zip([A|As], [B|Bs], [A-B|Cs]):- zip(As, Bs, Cs).

%nincs jól felkonfigurálva az ets, ezért nem találja az nth1 függvényt..
nth1_sajat(1, [L|_], L).
nth1_sajat(Index, [_|T], E):-
  nth1_sajat(I1, T, E),
  Index is I1 + 1.
