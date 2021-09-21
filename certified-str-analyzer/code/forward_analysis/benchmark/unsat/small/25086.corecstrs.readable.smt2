
var_0xINPUT_14632 := concat(T0_6, T1_6);

T0_6 in {
initial state: 0
state 0 [accept]:
};

var_0xINPUT_14632 in {
initial state: 0
state 0 [reject]:
  \u0000-\uffff -> 1
state 1 [accept]:
  \u0000-\uffff -> 1
};

T1_6 in {
initial state: 4
state 0 [reject]:
  \u0000-\uffff -> 3
state 1 [accept]:
  \u0000-N -> 3
  O -> 6
  P-\uffff -> 3
state 2 [accept]:
  \u0000-R -> 3
  T-\uffff -> 3
  S -> 1
state 3 [accept]:
  \u0000-\uffff -> 3
state 4 [accept]:
  \u0000-F -> 3
  G -> 5
  H-\uffff -> 3
state 5 [accept]:
  \u0000-@ -> 3
  B-\uffff -> 3
  A -> 2
state 6 [accept]:
  = -> 0
  \u0000-< -> 3
  >-\uffff -> 3
};

