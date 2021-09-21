
T2_2 := concat(T4_2, T5_2);
T1_2 := concat(T2_2, T3_2);
var_0xINPUT_2 := concat(T0_2, T1_2);

T5_2 in {
initial state: 1
state 0 [accept]:
state 1 [reject]:
  = -> 0
};

T0_2 in {
initial state: 0
state 0 [accept]:
};

T4_2 in {
initial state: 2
state 0 [accept]:
  \u0000-\uffff -> 0
state 1 [reject]:
  \u0000-\uffff -> 0
state 2 [accept]:
  = -> 1
  \u0000-< -> 0
  >-\uffff -> 0
};

