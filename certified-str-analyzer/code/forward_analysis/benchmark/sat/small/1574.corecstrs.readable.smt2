

PCTEMP_LHS_5 in {
initial state: 7
state 0 [accept]:
  \u0000-\uffff -> 0
state 1 [reject]:
  \u0000-\uffff -> 0
state 2 [accept]:
  c-\uffff -> 0
  \u0000-a -> 0
  b -> 8
state 3 [accept]:
  \u0000-b -> 0
  d-\uffff -> 0
  c -> 6
state 4 [accept]:
  \u0000-n -> 0
  o -> 2
  p-\uffff -> 0
state 5 [accept]:
  e -> 3
  f-\uffff -> 0
  \u0000-d -> 0
state 6 [accept]:
  u-\uffff -> 0
  t -> 1
  \u0000-s -> 0
state 7 [accept]:
  \u005c-\uffff -> 0
  [ -> 4
  \u0000-Z -> 0
state 8 [accept]:
  k-\uffff -> 0
  j -> 5
  \u0000-i -> 0
};

