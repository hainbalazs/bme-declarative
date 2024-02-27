:- use_module(library(ordsets)).


% :- type parcMutató ==    int-int.          % egy parcella helyét meghatározó egészszám-pár
% :- type fák ==           list(parcMutató). % a fák helyeit tartalmazó lista
% :- type irány    --->    n                 % észak
%                        ; e                 % kelet
%                        ; s                 % dél
%                        ; w.                % nyugat
% :- type iránylista ==    list(irany).      % egy adott fához rendelt sátor
                                             % lehetséges irányait megadó lista
% :- type iránylisták ==   list(iránylista). % az összes fa iránylistája

% :- type összegfeltétel
%                     ==   sor(int, int)     % sor(I,Db): az I-edik sorbeli sátrak száma Db
%                        ; oszl(int, int).   % oszl(J,Db): a J-edik oszlopbeli sátrak száma Db

% :- pred osszeg_szukites(fák::in,           % Fs
%                         összegfeltétel::in,% Osszegfeltetel
%                         iránylisták::in,   % ILs0
%                         iránylisták::out)  % ILs



% Elvégzi a feladatban kiírt szűkítést
osszeg_szukites(Fs, Osszegfeltetel, ILs0, ILs):-
  osszfelt_kibont(Osszegfeltetel, Dim, J, Db),
  zip(Fs, ILs0, FIs),
  % biztos odamutató elemek összegyűjtése
  findall(F-I, (member(F-I, FIs), irany(Dim, F, J, Ds), ord_subset(I, Ds)), B),
  % esetleg odamutató elemek összegyűjtése
  findall(F-I, (member(F-I, FIs), irany(Dim, F, J, Ds), ord_intersect(Ds, I), \+ member(F-I, B)), E),
  length(B, Lb),
  length(E, Le),
  Lbe is Lb + Le,
  (
  (Lb > Db; Lbe < Db) -> ILs = []   % (i, iv)
  ;
  Lbe is Db ->  findall(Dc,         % (ii)
                        (
                        member(F-I, FIs),
                        (member(F-I, E) -> irany(Dim, F, J, Ds), ord_intersection(Ds, I, Dc)
                        ;
                        Dc = I)
                        ),
                      ILs)
  ;
  Lb is Db -> findall(Dc,           % (iii)
                        (
                        member(F-I, FIs),
                        (member(F-I, E) -> irany(Dim, F, J, D), ord_subtract(I, D, Dc)
                        ;
                        Dc = I)
                        ),
                      ILs)
  ;
  fail
  ).

% Szétszedi az összegfeltétel kifejezést részeire
osszfelt_kibont(sor(N, Db), sor, N, Db).
osszfelt_kibont(oszl(M, Db), oszlop, M, Db).

% Ellenőrzi, hogy az Y-X koordinátájú parcella a J. sortól D irányra van e,
% és a J. vagy vele szomszédos sorban helyezkedik el.
% Ha a parcelle a J. sorban van, akkor az tőle keletre és nyugatra is van.
irany(sor, Y-_, J, D):-
  JMY is J - Y,
  (JMY is 0 -> D = [e,w]
  ;
  JMY is -1 -> D = [n]
  ;
  JMY is 1 -> D = [s]
  ;
  fail).

% Ellenőrzi, hogy az Y-X koordinátájú parcella a J. oszloptól D irányra van e,
% és a J. vagy vele szomszédos oszlopban helyezkedik el.
% Ha a parcelle a J. oszlopban van, akkor az tőle északra és délre is van.
irany(oszlop, _-X, J, D):-
  JMX is J - X,
  (JMX is 0 -> D = [n,s]
  ;
  JMX is -1 -> D = [w]
  ;
  JMX is 1 -> D = [e]
  ;
  fail).

% Két listát összefűz, úgy hogy elemei az eredeti két lista által alkotott Ai-Bi pár
zip([], [], []).
zip([A|As], [B|Bs], [A-B|Cs]):- zip(As, Bs, Cs).
