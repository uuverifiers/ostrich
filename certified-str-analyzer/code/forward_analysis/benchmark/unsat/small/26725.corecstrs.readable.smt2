
T_1 := concat(T1_4, T2_4);
T_4 := concat(T1_7, T2_4);

T_4 in {
initial state: 0
state 0 [accept]:
};

T1_7 in {
initial state: 0
state 0 [accept]:
};

T1_4 in {
initial state: 0
state 0 [accept]:
};

T_1 in {
initial state: 0
state 0 [reject]:
  \u0000-\uffff -> 1
state 1 [accept]:
  \u0000-\uffff -> 1
};

