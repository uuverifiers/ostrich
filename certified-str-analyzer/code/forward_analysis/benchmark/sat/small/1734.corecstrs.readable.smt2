
T2_6 := concat(T4_6, T5_6);
T1_6 := concat(T2_6, T3_6);
var_0xINPUT_15325 := concat(T0_6, T1_6);

T5_6 in {
initial state: 4
state 0 [reject]:
  A -> 5
state 1 [reject]:
  O -> 2
state 2 [reject]:
  = -> 3
state 3 [accept]:
state 4 [reject]:
  G -> 0
state 5 [reject]:
  S -> 1
};

T0_6 in {
initial state: 0
state 0 [accept]:
};

var_0xINPUT_15325 in {
initial state: 0
state 0 [reject]:
  \u0000-\uffff -> 1
state 1 [accept]:
  \u0000-\uffff -> 1
};

T4_6 in {
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

