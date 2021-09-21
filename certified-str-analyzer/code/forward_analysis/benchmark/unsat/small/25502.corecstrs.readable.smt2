
T2_5 := concat(T4_5, T5_5);
T1_5 := concat(T2_5, T3_5);
var_0xINPUT_18129 := concat(T0_5, T1_5);

var_0xINPUT_18129 in {
initial state: 0
state 0 [accept]:
};

T5_5 in {
initial state: 0
state 0 [reject]:
  G -> 4
state 1 [reject]:
  S -> 2
state 2 [reject]:
  O -> 3
state 3 [reject]:
  = -> 5
state 4 [reject]:
  A -> 1
state 5 [accept]:
};

T0_5 in {
initial state: 0
state 0 [accept]:
};

var_0xINPUT_18129 in {
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

T4_5 in {
initial state: 1
state 0 [accept]:
  \u0000-N -> 6
  O -> 4
  P-\uffff -> 6
state 1 [accept]:
  \u0000-F -> 6
  G -> 2
  H-\uffff -> 6
state 2 [accept]:
  \u0000-@ -> 6
  B-\uffff -> 6
  A -> 5
state 3 [reject]:
  \u0000-\uffff -> 6
state 4 [accept]:
  = -> 3
  \u0000-< -> 6
  >-\uffff -> 6
state 5 [accept]:
  \u0000-R -> 6
  T-\uffff -> 6
  S -> 0
state 6 [accept]:
  \u0000-\uffff -> 6
};

