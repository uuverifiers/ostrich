
var_0xINPUT_49879 := concat(T0_5, T1_5);

var_0xINPUT_49879 in {
initial state: 0
state 0 [accept]:
};

T_9 in {
initial state: 1
state 0 [accept]:
state 1 [reject]:
  - -> 0
};

T_7 in {
initial state: 1
state 0 [accept]:
state 1 [reject]:
  - -> 0
};

T0_5 in {
initial state: 0
state 0 [accept]:
};

var_0xINPUT_49879 in {
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
initial state: 16
state 0 [accept]:
  {-\uffff -> 10
  z -> 4
  \u0000-y -> 10
state 1 [accept]:
  3-\uffff -> 10
  \u0000-1 -> 10
  2 -> 15
state 2 [accept]:
  \u0000-^ -> 10
  _ -> 5
  `-\uffff -> 10
state 3 [accept]:
  5-\uffff -> 10
  4 -> 17
  \u0000-3 -> 10
state 4 [accept]:
  = -> 1
  \u0000-< -> 10
  >-\uffff -> 10
state 5 [accept]:
  u -> 6
  v-\uffff -> 10
  \u0000-t -> 10
state 6 [accept]:
  u-\uffff -> 10
  t -> 11
  \u0000-s -> 10
state 7 [accept]:
  \u0000-7 -> 10
  8 -> 18
  9-\uffff -> 10
state 8 [accept]:
  :-\uffff -> 10
  \u0000-8 -> 10
  9 -> 9
state 9 [accept]:
  \u0000-6 -> 10
  7 -> 12
  8-\uffff -> 10
state 10 [accept]:
  \u0000-\uffff -> 10
state 11 [accept]:
  m -> 0
  \u0000-l -> 10
  n-\uffff -> 10
state 12 [accept]:
  \u0000-6 -> 10
  7 -> 3
  8-\uffff -> 10
state 13 [reject]:
  \u0000-\uffff -> 10
state 14 [accept]:
  7-\uffff -> 10
  6 -> 8
  \u0000-5 -> 10
state 15 [accept]:
  \u0000-0 -> 10
  2-\uffff -> 10
  1 -> 7
state 16 [accept]:
  \u0000-^ -> 10
  _ -> 2
  `-\uffff -> 10
state 17 [accept]:
  . -> 13
  \u0000-- -> 10
  /-\uffff -> 10
state 18 [accept]:
  0 -> 14
  1-\uffff -> 10
  \u0000-/ -> 10
};

