
var_0xINPUT_49845 := concat(T0_5, T1_5);

var_0xINPUT_49845 in {
initial state: 0
state 0 [accept]:
};

T0_5 in {
initial state: 0
state 0 [accept]:
};

var_0xINPUT_49845 in {
initial state: 1
state 0 [accept]:
  \u0000-\uffff -> 0
state 1 [accept]:
  - -> 2
  \u0000-, -> 0
  .-\uffff -> 0
state 2 [reject]:
  \u0000-\uffff -> 0
};

T_7 in {
initial state: 1
state 0 [accept]:
  \u0000-\uffff -> 0
state 1 [accept]:
  - -> 2
  \u0000-, -> 0
  .-\uffff -> 0
state 2 [reject]:
  \u0000-\uffff -> 0
};

T1_5 in {
initial state: 10
state 0 [accept]:
  \u0000-^ -> 14
  _ -> 3
  `-\uffff -> 14
state 1 [accept]:
  \u0000-7 -> 14
  8 -> 6
  9-\uffff -> 14
state 2 [accept]:
  7-\uffff -> 14
  6 -> 16
  \u0000-5 -> 14
state 3 [accept]:
  u -> 4
  v-\uffff -> 14
  \u0000-t -> 14
state 4 [accept]:
  u-\uffff -> 14
  t -> 17
  \u0000-s -> 14
state 5 [accept]:
  {-\uffff -> 14
  z -> 7
  \u0000-y -> 14
state 6 [accept]:
  0 -> 2
  1-\uffff -> 14
  \u0000-/ -> 14
state 7 [accept]:
  = -> 8
  \u0000-< -> 14
  >-\uffff -> 14
state 8 [accept]:
  3-\uffff -> 14
  \u0000-1 -> 14
  2 -> 13
state 9 [accept]:
  \u0000-6 -> 14
  7 -> 18
  8-\uffff -> 14
state 10 [accept]:
  \u0000-^ -> 14
  _ -> 0
  `-\uffff -> 14
state 11 [accept]:
  . -> 12
  \u0000-- -> 14
  /-\uffff -> 14
state 12 [reject]:
  \u0000-\uffff -> 14
state 13 [accept]:
  \u0000-0 -> 14
  2-\uffff -> 14
  1 -> 1
state 14 [accept]:
  \u0000-\uffff -> 14
state 15 [accept]:
  4 -> 11
  5-\uffff -> 14
  \u0000-3 -> 14
state 16 [accept]:
  :-\uffff -> 14
  \u0000-8 -> 14
  9 -> 9
state 17 [accept]:
  m -> 5
  \u0000-l -> 14
  n-\uffff -> 14
state 18 [accept]:
  \u0000-6 -> 14
  7 -> 15
  8-\uffff -> 14
};

