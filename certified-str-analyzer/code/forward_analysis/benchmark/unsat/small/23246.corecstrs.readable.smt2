
var_0xINPUT_49879 := concat(T0_5, T1_5);

var_0xINPUT_49879 in {
initial state: 0
state 0 [accept]:
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

T0_5 in {
initial state: 0
state 0 [accept]:
};

var_0xINPUT_49879 in {
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

T_f in {
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

T1_5 in {
initial state: 10
state 0 [accept]:
  \u0000-^ -> 5
  _ -> 4
  `-\uffff -> 5
state 1 [accept]:
  u-\uffff -> 5
  t -> 14
  \u0000-s -> 5
state 2 [reject]:
  \u0000-\uffff -> 5
state 3 [accept]:
  7-\uffff -> 5
  6 -> 15
  \u0000-5 -> 5
state 4 [accept]:
  u -> 1
  v-\uffff -> 5
  \u0000-t -> 5
state 5 [accept]:
  \u0000-\uffff -> 5
state 6 [accept]:
  {-\uffff -> 5
  z -> 18
  \u0000-y -> 5
state 7 [accept]:
  \u0000-0 -> 5
  2-\uffff -> 5
  1 -> 8
state 8 [accept]:
  \u0000-7 -> 5
  8 -> 11
  9-\uffff -> 5
state 9 [accept]:
  \u0000-6 -> 5
  7 -> 16
  8-\uffff -> 5
state 10 [accept]:
  \u0000-^ -> 5
  _ -> 0
  `-\uffff -> 5
state 11 [accept]:
  0 -> 3
  1-\uffff -> 5
  \u0000-/ -> 5
state 12 [accept]:
  \u0000-6 -> 5
  7 -> 9
  8-\uffff -> 5
state 13 [accept]:
  3-\uffff -> 5
  \u0000-1 -> 5
  2 -> 7
state 14 [accept]:
  m -> 6
  \u0000-l -> 5
  n-\uffff -> 5
state 15 [accept]:
  :-\uffff -> 5
  \u0000-8 -> 5
  9 -> 12
state 16 [accept]:
  5-\uffff -> 5
  4 -> 17
  \u0000-3 -> 5
state 17 [accept]:
  . -> 2
  \u0000-- -> 5
  /-\uffff -> 5
state 18 [accept]:
  = -> 13
  \u0000-< -> 5
  >-\uffff -> 5
};

