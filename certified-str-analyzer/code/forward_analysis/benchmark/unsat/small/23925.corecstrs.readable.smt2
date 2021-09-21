
var_0xINPUT_16708 := concat(T0_6, T1_6);

T0_6 in {
initial state: 0
state 0 [accept]:
};

var_0xINPUT_16708 in {
initial state: 0
state 0 [reject]:
  \u0000-\uffff -> 1
state 1 [accept]:
  \u0000-\uffff -> 1
};

T1_6 in {
initial state: 15
state 0 [accept]:
  7-\uffff -> 5
  6 -> 3
  \u0000-5 -> 5
state 1 [accept]:
  u-\uffff -> 5
  t -> 7
  \u0000-s -> 5
state 2 [accept]:
  u -> 1
  v-\uffff -> 5
  \u0000-t -> 5
state 3 [accept]:
  :-\uffff -> 5
  \u0000-8 -> 5
  9 -> 4
state 4 [accept]:
  . -> 16
  \u0000-- -> 5
  /-\uffff -> 5
state 5 [accept]:
  \u0000-\uffff -> 5
state 6 [accept]:
  \u0000-^ -> 5
  _ -> 2
  `-\uffff -> 5
state 7 [accept]:
  m -> 8
  \u0000-l -> 5
  n-\uffff -> 5
state 8 [accept]:
  \u0000-` -> 5
  b-\uffff -> 5
  a -> 14
state 9 [accept]:
  \u0000-0 -> 5
  2-\uffff -> 5
  1 -> 0
state 10 [accept]:
  \u0000-0 -> 5
  2-\uffff -> 5
  1 -> 18
state 11 [accept]:
  \u0000-0 -> 5
  2-\uffff -> 5
  1 -> 13
state 12 [accept]:
  :-\uffff -> 5
  \u0000-8 -> 5
  9 -> 17
state 13 [accept]:
  7-\uffff -> 5
  6 -> 12
  \u0000-5 -> 5
state 14 [accept]:
  = -> 11
  \u0000-< -> 5
  >-\uffff -> 5
state 15 [accept]:
  \u0000-^ -> 5
  _ -> 6
  `-\uffff -> 5
state 16 [reject]:
  \u0000-\uffff -> 5
state 17 [accept]:
  5-\uffff -> 5
  4 -> 10
  \u0000-3 -> 5
state 18 [accept]:
  \u0000-2 -> 5
  4-\uffff -> 5
  3 -> 9
};

