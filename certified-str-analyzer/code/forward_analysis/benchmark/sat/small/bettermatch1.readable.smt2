
T1_2 := concat(PCTEMP_LHS_1_group_1, T2_2);
var_0xINPUT_9 := concat(T0_2, T1_2);

PCTEMP_LHS_1_group_1 in {
initial state: 3
state 0 [reject]:
  h -> 1
state 1 [reject]:
  n -> 4
state 2 [reject]:
  o -> 0
state 3 [reject]:
  j -> 2
state 4 [accept]:
};

T0_2 in {
initial state: 1
state 0 [reject]:
  \u0000-\uffff -> 3
state 1 [accept]:
  k-\uffff -> 3
  j -> 5
  \u0000-i -> 3
state 2 [accept]:
  n -> 0
  \u0000-m -> 3
  o-\uffff -> 3
state 3 [accept]:
  \u0000-\uffff -> 3
state 4 [accept]:
  \u0000-g -> 3
  h -> 2
  i-\uffff -> 3
state 5 [accept]:
  \u0000-n -> 3
  o -> 4
  p-\uffff -> 3
};

