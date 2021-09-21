

PCTEMP_LHS_1 in {
initial state: 3
state 0 [reject]:
  \u0000-\uffff -> 1
state 1 [accept]:
  \u0000-\uffff -> 1
state 2 [accept]:
  \u0000-r -> 1
  t-\uffff -> 1
  s -> 7
state 3 [accept]:
  % -> 4
  &-\uffff -> 1
  \u0000-$ -> 1
state 4 [accept]:
  \u0000-g -> 1
  h -> 5
  i-\uffff -> 1
state 5 [accept]:
  \u0000-n -> 1
  o -> 2
  p-\uffff -> 1
state 6 [accept]:
  % -> 0
  &-\uffff -> 1
  \u0000-$ -> 1
state 7 [accept]:
  u-\uffff -> 1
  t -> 6
  \u0000-s -> 1
};

