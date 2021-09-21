
var_0xINPUT_49879 := concat(T0_5, T1_5);
T_1 := concat(T1_3, T2_3);

T_7 in {
initial state: 1
state 0 [accept]:
state 1 [reject]:
  - -> 0
};

T_1 in {
initial state: 0
state 0 [accept]:
};

T1_3 in {
initial state: 0
state 0 [accept]:
};

T0_5 in {
initial state: 0
state 0 [accept]:
};

T_9 in {
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

T1_5 in {
initial state: 17
state 0 [accept]:
  u -> 1
  v-\uffff -> 6
  \u0000-t -> 6
state 1 [accept]:
  t -> 3
  u-\uffff -> 6
  \u0000-s -> 6
state 2 [accept]:
  \u0000-6 -> 6
  7 -> 7
  8-\uffff -> 6
state 3 [accept]:
  m -> 13
  \u0000-l -> 6
  n-\uffff -> 6
state 4 [accept]:
  \u0000-^ -> 6
  _ -> 0
  `-\uffff -> 6
state 5 [accept]:
  3-\uffff -> 6
  \u0000-1 -> 6
  2 -> 9
state 6 [accept]:
  \u0000-\uffff -> 6
state 7 [accept]:
  \u0000-6 -> 6
  7 -> 15
  8-\uffff -> 6
state 8 [accept]:
  . -> 18
  \u0000-- -> 6
  /-\uffff -> 6
state 9 [accept]:
  \u0000-0 -> 6
  2-\uffff -> 6
  1 -> 14
state 10 [accept]:
  0 -> 11
  1-\uffff -> 6
  \u0000-/ -> 6
state 11 [accept]:
  7-\uffff -> 6
  6 -> 12
  \u0000-5 -> 6
state 12 [accept]:
  :-\uffff -> 6
  \u0000-8 -> 6
  9 -> 2
state 13 [accept]:
  {-\uffff -> 6
  z -> 16
  \u0000-y -> 6
state 14 [accept]:
  \u0000-7 -> 6
  8 -> 10
  9-\uffff -> 6
state 15 [accept]:
  5-\uffff -> 6
  4 -> 8
  \u0000-3 -> 6
state 16 [accept]:
  = -> 5
  \u0000-< -> 6
  >-\uffff -> 6
state 17 [accept]:
  \u0000-^ -> 6
  _ -> 4
  `-\uffff -> 6
state 18 [reject]:
  \u0000-\uffff -> 6
};

