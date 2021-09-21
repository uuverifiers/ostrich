
var_0xINPUT_126103 := concat(T0_5, T1_5);

var_0xINPUT_126103 in {
initial state: 0
state 0 [accept]:
};

T0_5 in {
initial state: 0
state 0 [accept]:
};

var_0xINPUT_126103 in {
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
initial state: 15
state 0 [accept]:
  m -> 3
  \u0000-l -> 17
  n-\uffff -> 17
state 1 [accept]:
  3-\uffff -> 17
  \u0000-1 -> 17
  2 -> 6
state 2 [accept]:
  4 -> 13
  5-\uffff -> 17
  \u0000-3 -> 17
state 3 [accept]:
  w-\uffff -> 17
  v -> 4
  \u0000-u -> 17
state 4 [accept]:
  = -> 14
  \u0000-< -> 17
  >-\uffff -> 17
state 5 [accept]:
  7-\uffff -> 17
  6 -> 7
  \u0000-5 -> 17
state 6 [accept]:
  7-\uffff -> 17
  6 -> 2
  \u0000-5 -> 17
state 7 [accept]:
  \u0000-7 -> 17
  8 -> 8
  9-\uffff -> 17
state 8 [accept]:
  \u0000-7 -> 17
  8 -> 12
  9-\uffff -> 17
state 9 [reject]:
  \u0000-\uffff -> 17
state 10 [accept]:
  t -> 0
  u-\uffff -> 17
  \u0000-s -> 17
state 11 [accept]:
  \u0000-^ -> 17
  _ -> 16
  `-\uffff -> 17
state 12 [accept]:
  7-\uffff -> 17
  6 -> 1
  \u0000-5 -> 17
state 13 [accept]:
  . -> 9
  \u0000-- -> 17
  /-\uffff -> 17
state 14 [accept]:
  \u0000-0 -> 17
  2-\uffff -> 17
  1 -> 5
state 15 [accept]:
  \u0000-^ -> 17
  _ -> 11
  `-\uffff -> 17
state 16 [accept]:
  u -> 10
  v-\uffff -> 17
  \u0000-t -> 17
state 17 [accept]:
  \u0000-\uffff -> 17
};

