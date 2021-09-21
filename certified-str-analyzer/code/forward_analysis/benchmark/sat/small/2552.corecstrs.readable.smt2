
T2_2 := concat(T4_2, T5_2);
T1_2 := concat(T2_2, T3_2);
var_0xINPUT_204900 := concat(T0_2, T1_2);

T5_2 in {
initial state: 4
state 0 [reject]:
  p -> 5
state 1 [reject]:
  k -> 0
state 2 [reject]:
  r -> 6
state 3 [accept]:
state 4 [reject]:
  p -> 7
state 5 [reject]:
  = -> 3
state 6 [reject]:
  a -> 8
state 7 [reject]:
  t -> 2
state 8 [reject]:
  c -> 1
};

T0_2 in {
initial state: 0
state 0 [accept]:
};

T4_2 in {
initial state: 0
state 0 [accept]:
  p -> 5
  q-\uffff -> 2
  \u0000-o -> 2
state 1 [accept]:
  \u0000-` -> 2
  b-\uffff -> 2
  a -> 9
state 2 [accept]:
  \u0000-\uffff -> 2
state 3 [accept]:
  = -> 8
  \u0000-< -> 2
  >-\uffff -> 2
state 4 [accept]:
  p -> 3
  q-\uffff -> 2
  \u0000-o -> 2
state 5 [accept]:
  u-\uffff -> 2
  t -> 7
  \u0000-s -> 2
state 6 [accept]:
  l-\uffff -> 2
  k -> 4
  \u0000-j -> 2
state 7 [accept]:
  s-\uffff -> 2
  \u0000-q -> 2
  r -> 1
state 8 [reject]:
  \u0000-\uffff -> 2
state 9 [accept]:
  \u0000-b -> 2
  d-\uffff -> 2
  c -> 6
};

