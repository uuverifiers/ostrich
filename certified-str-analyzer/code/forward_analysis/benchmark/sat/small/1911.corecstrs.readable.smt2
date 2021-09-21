

PCTEMP_LHS_5 in {
initial state: 0
state 0 [accept]:
  \u005c-\uffff -> 2
  [ -> 7
  \u0000-Z -> 2
state 1 [accept]:
  c-\uffff -> 2
  \u0000-a -> 2
  b -> 8
state 2 [accept]:
  \u0000-\uffff -> 2
state 3 [accept]:
  \u0000-b -> 2
  d-\uffff -> 2
  c -> 6
state 4 [reject]:
  \u0000-\uffff -> 2
state 5 [accept]:
  e -> 3
  f-\uffff -> 2
  \u0000-d -> 2
state 6 [accept]:
  u-\uffff -> 2
  t -> 4
  \u0000-s -> 2
state 7 [accept]:
  \u0000-n -> 2
  o -> 1
  p-\uffff -> 2
state 8 [accept]:
  k-\uffff -> 2
  j -> 5
  \u0000-i -> 2
};

