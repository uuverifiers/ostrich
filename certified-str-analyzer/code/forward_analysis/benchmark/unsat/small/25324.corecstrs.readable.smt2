
var_0xINPUT_18334 := concat(T0_5, T1_5);

var_0xINPUT_18334 in {
initial state: 0
state 0 [accept]:
};

T0_5 in {
initial state: 0
state 0 [accept]:
};

var_0xINPUT_18334 in {
initial state: 1
state 0 [reject]:
  \u0000-\uffff -> 2
state 1 [accept]:
  - -> 0
  \u0000-, -> 2
  .-\uffff -> 2
state 2 [accept]:
  \u0000-\uffff -> 2
};

T1_5 in {
initial state: 5
state 0 [accept]:
  \u0000-N -> 3
  O -> 1
  P-\uffff -> 3
state 1 [accept]:
  = -> 4
  \u0000-< -> 3
  >-\uffff -> 3
state 2 [accept]:
  \u0000-@ -> 3
  B-\uffff -> 3
  A -> 6
state 3 [accept]:
  \u0000-\uffff -> 3
state 4 [reject]:
  \u0000-\uffff -> 3
state 5 [accept]:
  \u0000-F -> 3
  G -> 2
  H-\uffff -> 3
state 6 [accept]:
  \u0000-R -> 3
  T-\uffff -> 3
  S -> 0
};

