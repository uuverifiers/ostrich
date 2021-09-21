
T_1 := concat(T1_3, T2_3);

T2_3 in {
initial state: 0
state 0 [accept]:
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

