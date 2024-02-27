% tree_score(node(leaf(1),node(leaf(2),leaf(3))), N)

tree_score(leaf(_A), 0).
tree_score(node(B, C), N) :-
  tree_score(B, NB),
  tree_score(C, NC),
  N is NB + NC + 1.
