

PCTEMP_LHS_1 in {
initial state: 2
state 0 [reject]:
  \u0000-\uffff -> 1
state 1 [accept]:
  \u0000-\uffff -> 1
state 2 [accept]:
  % -> 0
  &-\uffff -> 1
  \u0000-$ -> 1
};

