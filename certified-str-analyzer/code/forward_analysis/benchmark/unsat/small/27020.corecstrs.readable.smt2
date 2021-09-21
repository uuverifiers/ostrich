
T_1 := concat(T1_3, T2_3);

T1_3 in {
initial state: 3
state 0 [accept]:
state 1 [reject]:
  n -> 5
state 2 [reject]:
  n -> 0
state 3 [reject]:
  / -> 6
state 4 [reject]:
  g -> 1
state 5 [reject]:
  i -> 2
state 6 [reject]:
  s -> 7
state 7 [reject]:
  i -> 4
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

