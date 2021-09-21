

PCTEMP_LHS_5 in {
initial state: 6
state 0 [accept]:
  \u0000-b -> 4
  d-\uffff -> 4
  c -> 3
state 1 [reject]:
  \u0000-\uffff -> 4
state 2 [accept]:
  e -> 0
  f-\uffff -> 4
  \u0000-d -> 4
state 3 [accept]:
  t -> 1
  u-\uffff -> 4
  \u0000-s -> 4
state 4 [accept]:
  \u0000-\uffff -> 4
state 5 [accept]:
  k-\uffff -> 4
  j -> 2
  \u0000-i -> 4
state 6 [accept]:
  \u005c-\uffff -> 4
  [ -> 7
  \u0000-Z -> 4
state 7 [accept]:
  \u0000-n -> 4
  o -> 8
  p-\uffff -> 4
state 8 [accept]:
  c-\uffff -> 4
  \u0000-a -> 4
  b -> 5
};

