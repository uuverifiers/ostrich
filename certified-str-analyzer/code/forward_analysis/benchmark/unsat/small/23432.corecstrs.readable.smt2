
var_0xINPUT_89804 := concat(T0_5, T1_5);

var_0xINPUT_89804 in {
initial state: 0
state 0 [accept]:
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

var_0xINPUT_89804 in {
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

T_b in {
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

T1_5 in {
initial state: 15
state 0 [accept]:
  {-\uffff -> 12
  z -> 4
  \u0000-y -> 12
state 1 [accept]:
  \u0000-0 -> 12
  2-\uffff -> 12
  1 -> 14
state 2 [accept]:
  \u0000-^ -> 12
  _ -> 5
  `-\uffff -> 12
state 3 [accept]:
  . -> 16
  \u0000-- -> 12
  /-\uffff -> 12
state 4 [accept]:
  = -> 1
  \u0000-< -> 12
  >-\uffff -> 12
state 5 [accept]:
  u -> 6
  v-\uffff -> 12
  \u0000-t -> 12
state 6 [accept]:
  t -> 10
  u-\uffff -> 12
  \u0000-s -> 12
state 7 [accept]:
  \u0000-7 -> 12
  8 -> 17
  9-\uffff -> 12
state 8 [accept]:
  3-\uffff -> 12
  \u0000-1 -> 12
  2 -> 9
state 9 [accept]:
  7-\uffff -> 12
  6 -> 11
  \u0000-5 -> 12
state 10 [accept]:
  m -> 0
  \u0000-l -> 12
  n-\uffff -> 12
state 11 [accept]:
  4 -> 3
  5-\uffff -> 12
  \u0000-3 -> 12
state 12 [accept]:
  \u0000-\uffff -> 12
state 13 [accept]:
  7-\uffff -> 12
  6 -> 8
  \u0000-5 -> 12
state 14 [accept]:
  7-\uffff -> 12
  6 -> 7
  \u0000-5 -> 12
state 15 [accept]:
  \u0000-^ -> 12
  _ -> 2
  `-\uffff -> 12
state 16 [reject]:
  \u0000-\uffff -> 12
state 17 [accept]:
  \u0000-7 -> 12
  8 -> 13
  9-\uffff -> 12
};

