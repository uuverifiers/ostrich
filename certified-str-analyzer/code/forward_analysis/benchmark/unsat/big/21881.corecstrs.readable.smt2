
var_0xINPUT_49879 := concat(T0_5, T1_5);

var_0xINPUT_49879 in {
initial state: 0
state 0 [accept]:
};

T_f in {
initial state: 0
state 0 [reject]:
  - -> 1
state 1 [accept]:
};

T_d in {
initial state: 0
state 0 [reject]:
  - -> 1
state 1 [accept]:
};

T_b in {
initial state: 0
state 0 [reject]:
  - -> 1
state 1 [accept]:
};

T_9 in {
initial state: 0
state 0 [reject]:
  - -> 1
state 1 [accept]:
};

T_7 in {
initial state: 0
state 0 [reject]:
  - -> 1
state 1 [accept]:
};

T_1e in {
initial state: 0
state 0 [reject]:
  - -> 1
state 1 [accept]:
};

T_1c in {
initial state: 0
state 0 [reject]:
  - -> 1
state 1 [accept]:
};

T_1a in {
initial state: 0
state 0 [reject]:
  - -> 1
state 1 [accept]:
};

T_18 in {
initial state: 0
state 0 [reject]:
  - -> 1
state 1 [accept]:
};

T_16 in {
initial state: 0
state 0 [reject]:
  - -> 1
state 1 [accept]:
};

T_14 in {
initial state: 0
state 0 [reject]:
  - -> 1
state 1 [accept]:
};

T0_5 in {
initial state: 0
state 0 [accept]:
};

var_0xINPUT_49879 in {
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

T_11 in {
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

T1_5 in {
initial state: 10
state 0 [accept]:
  \u0000-6 -> 18
  7 -> 14
  8-\uffff -> 18
state 1 [accept]:
  t -> 8
  u-\uffff -> 18
  \u0000-s -> 18
state 2 [reject]:
  \u0000-\uffff -> 18
state 3 [accept]:
  \u0000-0 -> 18
  2-\uffff -> 18
  1 -> 11
state 4 [accept]:
  0 -> 13
  1-\uffff -> 18
  \u0000-/ -> 18
state 5 [accept]:
  3-\uffff -> 18
  \u0000-1 -> 18
  2 -> 3
state 6 [accept]:
  . -> 2
  \u0000-- -> 18
  /-\uffff -> 18
state 7 [accept]:
  4 -> 6
  5-\uffff -> 18
  \u0000-3 -> 18
state 8 [accept]:
  m -> 9
  \u0000-l -> 18
  n-\uffff -> 18
state 9 [accept]:
  {-\uffff -> 18
  z -> 16
  \u0000-y -> 18
state 10 [accept]:
  \u0000-^ -> 18
  _ -> 15
  `-\uffff -> 18
state 11 [accept]:
  \u0000-7 -> 18
  8 -> 4
  9-\uffff -> 18
state 12 [accept]:
  :-\uffff -> 18
  \u0000-8 -> 18
  9 -> 0
state 13 [accept]:
  7-\uffff -> 18
  6 -> 12
  \u0000-5 -> 18
state 14 [accept]:
  \u0000-6 -> 18
  7 -> 7
  8-\uffff -> 18
state 15 [accept]:
  \u0000-^ -> 18
  _ -> 17
  `-\uffff -> 18
state 16 [accept]:
  = -> 5
  \u0000-< -> 18
  >-\uffff -> 18
state 17 [accept]:
  u -> 1
  v-\uffff -> 18
  \u0000-t -> 18
state 18 [accept]:
  \u0000-\uffff -> 18
};

