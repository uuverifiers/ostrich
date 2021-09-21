
T2_2 := concat(T4_2, T5_2);
T1_2 := concat(T2_2, T3_2);
var_0xINPUT_179785 := concat(T0_2, T1_2);

T5_2 in {
initial state: 0
state 0 [reject]:
  p -> 4
state 1 [accept]:
state 2 [reject]:
  = -> 1
state 3 [reject]:
  a -> 5
state 4 [reject]:
  t -> 6
state 5 [reject]:
  c -> 7
state 6 [reject]:
  r -> 3
state 7 [reject]:
  k -> 2
};

T0_2 in {
initial state: 0
state 0 [accept]:
};

T4_2 in {
initial state: 0
state 0 [accept]:
  p -> 4
  q-\uffff -> 7
  \u0000-o -> 7
state 1 [accept]:
  \u0000-` -> 7
  b-\uffff -> 7
  a -> 8
state 2 [reject]:
  \u0000-\uffff -> 7
state 3 [accept]:
  = -> 2
  \u0000-< -> 7
  >-\uffff -> 7
state 4 [accept]:
  t -> 6
  u-\uffff -> 7
  \u0000-s -> 7
state 5 [accept]:
  l-\uffff -> 7
  k -> 3
  \u0000-j -> 7
state 6 [accept]:
  s-\uffff -> 7
  \u0000-q -> 7
  r -> 1
state 7 [accept]:
  \u0000-\uffff -> 7
state 8 [accept]:
  \u0000-b -> 7
  d-\uffff -> 7
  c -> 5
};

