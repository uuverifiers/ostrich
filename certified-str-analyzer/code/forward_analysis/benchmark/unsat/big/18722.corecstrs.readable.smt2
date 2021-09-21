
T_7 := concat(T1_12, T2_12);
T_a := concat(T1_16, T2_12);
T_d := concat(T1_20, T2_12);
T_10 := concat(T1_24, T2_12);
T_13 := concat(T1_28, T2_12);
T_16 := concat(T1_32, T2_12);
T_19 := concat(T1_36, T2_12);
T_1c := concat(T1_39, T2_12);
T_1 := concat(T1_4, T2_12);
T_4 := concat(T1_8, T2_12);

T_1c in {
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

T1_39 in {
initial state: 0
state 0 [accept]:
};

T1_36 in {
initial state: 0
state 0 [accept]:
};

T1_32 in {
initial state: 0
state 0 [accept]:
};

T1_28 in {
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
initial state: 1
state 0 [accept]:
  \u0000-\uffff -> 0
state 1 [reject]:
  \u0000-\uffff -> 0
};

T_7 in {
initial state: 1
state 0 [accept]:
  \u0000-\uffff -> 0
state 1 [reject]:
  \u0000-\uffff -> 0
};

T_4 in {
initial state: 1
state 0 [accept]:
  \u0000-\uffff -> 0
state 1 [reject]:
  \u0000-\uffff -> 0
};

T_19 in {
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

T_16 in {
initial state: 1
state 0 [accept]:
  \u0000-\uffff -> 0
state 1 [reject]:
  \u0000-\uffff -> 0
};

T_13 in {
initial state: 1
state 0 [accept]:
  \u0000-\uffff -> 0
state 1 [reject]:
  \u0000-\uffff -> 0
};

T_10 in {
initial state: 1
state 0 [accept]:
  \u0000-\uffff -> 0
state 1 [reject]:
  \u0000-\uffff -> 0
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

