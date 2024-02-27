% tree_increment(node(leaf(1),node(leaf(2),leaf(3))), Tree).

tree_increment(leaf(A), Tree):-
  A1 is A + 1,
  Tree = leaf(A1).
tree_increment(node(A, B), Tree) :-
  tree_increment(A, A1),
  tree_increment(B, B1),
  Tree = node(A1, B1).
