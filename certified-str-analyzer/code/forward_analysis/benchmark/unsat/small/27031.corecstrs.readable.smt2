
T_1 := concat(T1_3, T2_3);

T2_3 in {
initial state: 2
state 0 [reject]:
  c -> 4
state 1 [accept]:
state 2 [reject]:
  s -> 5
state 3 [reject]:
  r -> 0
state 4 [reject]:
  h -> 1
state 5 [reject]:
  e -> 6
state 6 [reject]:
  a -> 3
};

PCTEMP_LHS_1 in {
initial state: 0
state 0 [accept]:
  % -> 1
  &-\uffff -> 2
  \u0000-$ -> 2
state 1 [reject]:
  \u0000-\uffff -> 2
state 2 [accept]:
  \u0000-\uffff -> 2
};

