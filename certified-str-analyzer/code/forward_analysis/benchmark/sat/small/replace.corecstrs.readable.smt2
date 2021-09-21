
T2_4 := concat(T4_4, T5_4);
T1_2 := concat(T2_2, T3_2);
T1_4 := concat(T2_4, T3_4);
T4_2 := concat(T5_2, T3_2);
var_0xINPUT_2 := concat(T0_2, T1_2);
PCTEMP_LHS_1 := concat(T0_4, T1_4);
PCTEMP_LHS_1 := concat(T0_2, T4_2);

T5_4 in {
initial state: 1
state 0 [accept]:
state 1 [reject]:
  _ -> 0
};

T5_2 in {
initial state: 1
state 0 [accept]:
state 1 [reject]:
  _ -> 0
};

T2_2 in {
initial state: 0
state 0 [reject]:
  = -> 1
state 1 [accept]:
};

T0_4 in {
initial state: 0
state 0 [accept]:
};

T4_4 in {
initial state: 0
state 0 [accept]:
  \u0000-^ -> 1
  _ -> 2
  `-\uffff -> 1
state 1 [accept]:
  \u0000-\uffff -> 1
state 2 [reject]:
  \u0000-\uffff -> 1
};

T0_2 in {
initial state: 1
state 0 [reject]:
  \u0000-\uffff -> 2
state 1 [accept]:
  = -> 0
  \u0000-< -> 2
  >-\uffff -> 2
state 2 [accept]:
  \u0000-\uffff -> 2
};

