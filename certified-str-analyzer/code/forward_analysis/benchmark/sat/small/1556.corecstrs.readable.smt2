

PCTEMP_LHS_5 in {
initial state: 3
state 0 [accept]:
  u-\uffff -> 1
  t -> 8
  \u0000-s -> 1
state 1 [accept]:
  \u0000-\uffff -> 1
state 2 [accept]:
  \u0000-b -> 1
  d-\uffff -> 1
  c -> 0
state 3 [accept]:
  \u005c-\uffff -> 1
  [ -> 7
  \u0000-Z -> 1
state 4 [accept]:
  k-\uffff -> 1
  j -> 6
  \u0000-i -> 1
state 5 [accept]:
  c-\uffff -> 1
  \u0000-a -> 1
  b -> 4
state 6 [accept]:
  e -> 2
  f-\uffff -> 1
  \u0000-d -> 1
state 7 [accept]:
  \u0000-n -> 1
  o -> 5
  p-\uffff -> 1
state 8 [reject]:
  \u0000-\uffff -> 1
};

