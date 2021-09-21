

PCTEMP_LHS_4 in {
initial state: 0
state 0 [accept]:
};

PCTEMP_LHS_5 in {
initial state: 7
state 0 [accept]:
  e -> 4
  f-\uffff -> 6
  \u0000-d -> 6
state 1 [reject]:
  \u0000-\uffff -> 6
state 2 [accept]:
  t -> 1
  u-\uffff -> 6
  \u0000-s -> 6
state 3 [accept]:
  k-\uffff -> 6
  j -> 0
  \u0000-i -> 6
state 4 [accept]:
  \u0000-b -> 6
  d-\uffff -> 6
  c -> 2
state 5 [accept]:
  c-\uffff -> 6
  \u0000-a -> 6
  b -> 3
state 6 [accept]:
  \u0000-\uffff -> 6
state 7 [accept]:
  \u005c-\uffff -> 6
  [ -> 8
  \u0000-Z -> 6
state 8 [accept]:
  \u0000-n -> 6
  o -> 5
  p-\uffff -> 6
};

