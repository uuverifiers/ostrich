
T_6 := concat(T1_10, T2_10);
T_6 := concat(T0_11, T1_11);
T_a := concat(T1_16, T2_10);
T_1 := concat(T1_4, T2_10);
T_4 := concat(T1_7, T2_10);

T_a in {
initial state: 1
state 0 [accept]:
state 1 [reject]:
  - -> 0
};

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

T1_16 in {
initial state: 0
state 0 [accept]:
};

T1_10 in {
initial state: 0
state 0 [accept]:
};

T0_11 in {
initial state: 0
state 0 [accept]:
};

T_1 in {
initial state: 2
state 0 [accept]:
  \u0000-\uffff -> 0
state 1 [reject]:
  \u0000-\uffff -> 0
state 2 [accept]:
  - -> 1
  \u0000-, -> 0
  .-\uffff -> 0
};

T1_11 in {
initial state: 1
state 0 [accept]:
  u-\uffff -> 2
  t -> 4
  \u0000-s -> 2
state 1 [accept]:
  u -> 0
  v-\uffff -> 2
  \u0000-t -> 2
state 2 [accept]:
  \u0000-\uffff -> 2
state 3 [accept]:
  e-\uffff -> 2
  d -> 8
  \u0000-c -> 2
state 4 [accept]:
  m -> 6
  \u0000-l -> 2
  n-\uffff -> 2
state 5 [accept]:
  j-\uffff -> 2
  \u0000-h -> 2
  i -> 3
state 6 [accept]:
  \u0000-^ -> 2
  _ -> 5
  `-\uffff -> 2
state 7 [reject]:
  \u0000-\uffff -> 2
state 8 [accept]:
  = -> 7
  \u0000-< -> 2
  >-\uffff -> 2
};

