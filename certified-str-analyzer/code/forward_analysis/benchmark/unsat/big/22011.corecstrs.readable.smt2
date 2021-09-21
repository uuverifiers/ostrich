
T_7 := concat(T1_12, T2_12);
T_a := concat(T1_16, T2_12);
T_d := concat(T1_20, T2_12);
T_10 := concat(T1_24, T2_12);
T_13 := concat(T1_27, T2_12);
T_1 := concat(T1_4, T2_12);
T_4 := concat(T1_8, T2_12);

T_13 in {
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

T1_27 in {
initial state: 0
state 0 [accept]:
};

T1_24 in {
initial state: 0
state 0 [accept]:
};

T1_20 in {
initial state: 0
state 0 [accept]:
};

T1_16 in {
initial state: 0
state 0 [accept]:
};

T1_12 in {
initial state: 0
state 0 [accept]:
};

T_d in {
initial state: 2
state 0 [reject]:
  \u0000-\uffff -> 1
state 1 [accept]:
  \u0000-\uffff -> 1
state 2 [accept]:
  - -> 0
  \u0000-, -> 1
  .-\uffff -> 1
};

T_a in {
initial state: 0
state 0 [reject]:
  \u0000-\uffff -> 1
state 1 [accept]:
  \u0000-\uffff -> 1
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

T_10 in {
initial state: 0
state 0 [reject]:
  \u0000-\uffff -> 1
state 1 [accept]:
  \u0000-\uffff -> 1
};

T_1 in {
initial state: 2
state 0 [reject]:
  \u0000-\uffff -> 1
state 1 [accept]:
  \u0000-\uffff -> 1
state 2 [accept]:
  - -> 0
  \u0000-, -> 1
  .-\uffff -> 1
};

