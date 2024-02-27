:- use_module(library(lists)).
:- use_module(library(between)).
:- use_module(library(ordsets)).
:- use_module(library(aggregate)).

satrak(satrak(Ss, Os, Fs), ILs) :-
  % feladavány alapparamétereinek feldolgozása
  length(Ss, N),
  length(Os, M),
  create_sumconstraints(Ss, Os, Cs),
  iranylistak(N-M, Fs, ILs0),
  zip(Fs, ILs0, FIs),
  % ellenőrző végrehajtása
  solve(N-M, Nums, Cs, FIs, [], ILsR),
  clumps(ILs, ILsR).

solve(_, _, _, [], FIsS, ILs):-
  sort(FIsS, Sorted),
  findall(I, member(F-I, Sorted), ILs).

solve(NM, Nums, Cs, FIs0, FIsS, ILs):-
  %append(FIsS, FIs0, DIRS),
  length(FIs0, L),
  nums_fromN_toM(1, L, Nums),
  scanlist(sator_szukites, Nums, FIs0, DIRS1),
  scanlist(osszeg_szukites, Cs, DIRS1-[], DIRS2-NoConst),
  remove_const(Cs, NoConst, Cs1),
  (FIs0 == DIRS2 ->
    onelength_sublist(DIRS2, FIsS2, FIs2),
    scanlist(mod_constraints, FIsS2, Cs1, Cs2),
    append(FIsS, FIsS2, FIsS3),

    get_shortest_sublist(FIs2, H, DT),
    (H \= [] ->
      FH-DH = H,
      member(Ds, DH),
      FIs3 = [FH-[Ds]|DT]
    ;
     FIs3 = []),

     length(FIs2, Ln),
     take(Ln, Nums, Num1),

    %append(FIsS, [FH-[Ds]], FIsS2),

    %append(ILsS2, DT, ILs3),
    % (C1) Minden fához rendelünk sátrat -> IGEN: #iranylistak
    % (C2) Minden fához csak hozzá oldalszomédos sátrat rendelünk -> IGEN: #iranylistak
    % (C4) Sátrak nem oldalszomszédok / nincsenek egymáson
      % csak a kiválasztottakra ellenőrizzük
    %length(ILsS2, LS),
    %take(LS, Fs, FsS),
    % n*n/2-se teheto TODO
    %check_neighbour(FsS, ILsS2),

    % (C3) Összegfeltételek teljesülnek
      % összesre ellenőrizzük (lehetetlen kizárása)
      % fel lehet gyorsitani a masodik osszeg_szukites-t
      % hiszen b' = b+1 / b ; e'= e-1 / e; --> b'+e' = b+e, b+e-1, b+e+1
      % elhagyhato Ils aggregalasa
    %forall(member(C, Cs), osszeg_szukites_gyors(Fs, C, ILs3)),

    solve(NM, Nums1, Cs2, FIs3, FIsS3, ILs)
  ;
  DIRS2 == [] -> fail
  ;
  solve(NM, Nums, Cs1, DIRS2, FIsS, ILs)
  ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% START Satrak.pl %%%%
%%
mod_constraints(F-[D], Cs0, Cs):-
  calc_coord(F, D, TY-TX),
  findall(CN, (
                member(C, Cs0),
                (
                  sor(TY, Db) = C ->
                    (Db > 0 -> Dbn is Db - 1, CN = sor(TY, Dbn)
                    ;
                    Db == 0 -> CN = infeasible
                    ;
                    CN = sor(TY, Db)
                    )
                  ;
                  oszl(TX, Db) = C ->
                    (Db > 0 -> Dbn is Db - 1, CN = oszl(TX, Dbn)
                    ;
                    Db == 0 -> CN = infeasible
                    ;
                    CN = oszl(TX, Db)
                    )
                  ;
                  CN = C
                )
              ), Cs),
    \+ member(infeasible, Cs).

remove_const(Cs, ToRem, Cs1):-
  findall(C, (
                member(C, Cs),
                (sor(I, _) = C -> \+ member(sor-I, ToRem)
                ;
                oszl(J, _) = C -> \+ member(oszl-J, ToRem)
                ;
                true)
              ), Cs1).

get_shortest_sublist([], [], []).
get_shortest_sublist(L, S, R):-
  aggregate(min(C,FE-IE),(member(FE-IE,L),length(IE,C), C > 1),min(_,S)),
  select(S, L, R), !.

onelength_sublist([], [], []).
onelength_sublist([FH-LH|LT], OLT, [RH|RT]):-
  \+ length(LH, 1),
  RH = FH-LH,
  onelength_sublist(LT, OLT, RT).
onelength_sublist([FH-LH|LT], [OneLengthH|OLT], Rest):-
  length(LH, 1),
  OneLengthH = FH-LH,
  onelength_sublist(LT, OLT, Rest).

create_sumconstraints(Ss, Os, Cs):-
  row_constraints(Ss, CRs),
  col_constraints(Os, CCs),
  append(CRs, CCs, Cs).

row_constraints(Ss, CRs):-
  el_idx(Ss, SsR),
  findall(sor(I, Db), (member(Db-I, SsR), Db >= 0), CRs).

col_constraints(Os, CCs):-
  el_idx(Os, OsR),
  findall(oszl(I, Db), (member(Db-I, OsR), Db >= 0), CCs).

el_idx(L, R):-
  el_idx_s(L, 1, R).

el_idx_s([], _, []).
el_idx_s([LH|LT], N, [RH|RT]):-
  RH = LH-N,
  N1 is N+1,
  el_idx_s(LT, N1, RT).

nums_fromN_toM(M, M, [M]):- !.
nums_fromN_toM(N, M, [L|LT]):-
  N =< M,
  L = N,
  N1 is N+1,
  nums_fromN_toM(N1, M, LT).

take(N, _, Xs) :- N =< 0, !, N =:= 0, Xs = [].
take(_, [], []).
take(N, [X|Xs], [X|Ys]) :- M is N-1, take(M, Xs, Ys).


%%% END Satrak.pl %%%%

%%% START KHF2 %%%%
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
  sator_szukites(_, [], FIs) :- !, FIs = [].
  sator_szukites(I, FIs0, FIs) :-
    nth1(I, FIs0, F-Ds),
    length(Ds, DL),
    DL > 1, !,
    FIs = FIs0.
  sator_szukites(I, FIs0, FIs) :-
    nth1(I, FIs0, F-[D]),
    calc_coord(F, D, Ts),
    find_neighbours(Ts, Ns),

    findall(Fi-Cs, (member(Fi-Di, FIs0),
                findall(Dii-Ci, (member(Dii, Di), calc_coord(Fi, Dii, Ci)), Cs)),
            FCs),


    findall(Fi2-DLi2,
      (member(Fi2-Ci2, FCs),
       findall(Dii2, (member(Dii2-Cii2, Ci2), (Fi2 \= F ->  \+ member(Cii2, Ns); true)),
       DLi2)),
    Res),
    \+ member([], Res),
    FIs = Res.

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

%%% END KHF2 %%%%

%%% START KHF3 %%%%

% Elvégzi a feladatban kiírt szűkítést
osszeg_szukites(Osszegfeltetel, FIs0, FIs):-
  osszfelt_kibont(Osszegfeltetel, Dim, J, Db),
  ossz_szuk_s(Dim, J, Db, FIs0, FIs).

ossz_szuk_s(_, _, _, [], FIs):- !, FIs = []-[].

ossz_szuk_s(_, _, Db, FIs0, FIs):-
  Db < 0,
  !,
  FIs = FIs0.

ossz_szuk_s(Dim, J, Db, Acc, Res):-
  Acc = FIs0-NoConst,
  % biztos odamutató elemek összegyűjtése
  findall(F-I, (member(F-I, FIs0), length(I, LI), LI =< 2,  irany(Dim, F, J, Ds), ord_subset(I, Ds)), B),
  % esetleg odamutató elemek összegyűjtése
  findall(F-I, (member(F-I, FIs0), irany(Dim, F, J, Ds), ord_intersect(Ds, I), \+ member(F-I, B)), E),
  length(B, Lb),
  length(E, Le),
  Lbe is Lb + Le,
  ((Lb == 0, Le == 0) -> NoConst1 = [Dim-J | NoConst];
  NoConst1 = NoConst
  ),
  (
  (Lb > Db; Lbe < Db) -> fail   % (i, iv)
  ;
  Lbe is Db ->  findall(F-Dc,         % (ii)
                        (
                        member(F-I, FIs0),
                        (member(F-I, E) -> irany(Dim, F, J, Ds), ord_intersection(Ds, I, Dc)
                        ;
                        Dc = I)
                        ),
                      FIs)
  ;
  Lb is Db -> findall(F-Dc,           % (iii)
                        (
                        member(F-I, FIs0),
                        (member(F-I, E) -> irany(Dim, F, J, D), ord_subtract(I, D, Dc)
                        ;
                        Dc = I)
                        ),
                      FIs)
  ;
  FIs = FIs0
  ),
  Res = FIs-NoConst1.


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

%%% END KHF3 %%%%
