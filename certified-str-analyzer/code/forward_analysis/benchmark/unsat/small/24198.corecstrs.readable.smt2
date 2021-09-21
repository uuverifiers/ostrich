
var_0xINPUT_47348 := concat(T0_5, T1_5);

var_0xINPUT_47348 in {
initial state: 0
state 0 [accept]:
};

T0_5 in {
initial state: 0
state 0 [accept]:
};

var_0xINPUT_47348 in {
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
initial state: 16
state 0 [accept]:
  m -> 3
  \u0000-l -> 13
  n-\uffff -> 13
state 1 [accept]:
  :-\uffff -> 13
  \u0000-8 -> 13
  9 -> 6
state 2 [accept]:
  \u0000-6 -> 13
  7 -> 14
  8-\uffff -> 13
state 3 [accept]:
  w-\uffff -> 13
  v -> 4
  \u0000-u -> 13
state 4 [accept]:
  = -> 15
  \u0000-< -> 13
  >-\uffff -> 13
state 5 [accept]:
  \u0000-0 -> 13
  2-\uffff -> 13
  1 -> 7
state 6 [accept]:
  \u0000-6 -> 13
  7 -> 2
  8-\uffff -> 13
state 7 [accept]:
  \u0000-7 -> 13
  8 -> 8
  9-\uffff -> 13
state 8 [accept]:
  0 -> 12
  1-\uffff -> 13
  \u0000-/ -> 13
state 9 [accept]:
  . -> 18
  \u0000-- -> 13
  /-\uffff -> 13
state 10 [accept]:
  t -> 0
  u-\uffff -> 13
  \u0000-s -> 13
state 11 [accept]:
  \u0000-^ -> 13
  _ -> 17
  `-\uffff -> 13
state 12 [accept]:
  7-\uffff -> 13
  6 -> 1
  \u0000-5 -> 13
state 13 [accept]:
  \u0000-\uffff -> 13
state 14 [accept]:
  4 -> 9
  5-\uffff -> 13
  \u0000-3 -> 13
state 15 [accept]:
  3-\uffff -> 13
  \u0000-1 -> 13
  2 -> 5
state 16 [accept]:
  \u0000-^ -> 13
  _ -> 11
  `-\uffff -> 13
state 17 [accept]:
  u -> 10
  v-\uffff -> 13
  \u0000-t -> 13
state 18 [reject]:
  \u0000-\uffff -> 13
};

