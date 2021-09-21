
T_7 := concat(T1_12, T2_12);
T_a := concat(T1_15, T2_12);
T_1 := concat(T1_4, T2_12);
T_4 := concat(T1_8, T2_12);

T_a in {
initial state: 0
state 0 [accept]:
};

T1_8 in {
initial state: 0
state 0 [accept]:
};

T1_4 in {
initial state: 0
state 0 [accept]:
};

T1_15 in {
initial state: 0
state 0 [accept]:
};

T1_12 in {
initial state: 0
state 0 [accept]:
};

T_7 in {
initial state: 0
state 0 [reject]:
  \u0000-\uffff -> 1
state 1 [accept]:
  \u0000-\uffff -> 1
};

T_4 in {
initial state: 0
state 0 [reject]:
  \u0000-\uffff -> 1
state 1 [accept]:
  \u0000-\uffff -> 1
};

T_1 in {
initial state: 0
state 0 [accept]:
  - -> 1
  \u0000-, -> 2
  .-\uffff -> 2
state 1 [reject]:
  \u0000-\uffff -> 2
state 2 [accept]:
  \u0000-\uffff -> 2
};

