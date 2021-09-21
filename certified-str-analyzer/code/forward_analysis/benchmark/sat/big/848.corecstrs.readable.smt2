

PCTEMP_LHS_5 in {
initial state: 3
state 0 [accept]:
  \u0000-\uffff -> 0
state 1 [accept]:
  \u0000-n -> 0
  o -> 4
  p-\uffff -> 0
state 2 [accept]:
  e -> 5
  f-\uffff -> 0
  \u0000-d -> 0
state 3 [accept]:
  \u005c-\uffff -> 0
  [ -> 1
  \u0000-Z -> 0
state 4 [accept]:
  c-\uffff -> 0
  \u0000-a -> 0
  b -> 8
state 5 [accept]:
  \u0000-b -> 0
  d-\uffff -> 0
  c -> 6
state 6 [accept]:
  u-\uffff -> 0
  t -> 7
  \u0000-s -> 0
state 7 [reject]:
  \u0000-\uffff -> 0
state 8 [accept]:
  k-\uffff -> 0
  j -> 2
  \u0000-i -> 0
};

