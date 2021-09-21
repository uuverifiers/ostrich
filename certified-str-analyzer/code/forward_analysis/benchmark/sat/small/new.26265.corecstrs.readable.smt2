
var_0xINPUT_173394 := concat(T0_2, T1_2);

T0_2 in {
initial state: 0
state 0 [accept]:
};

T1_2 in {
initial state: 3
state 0 [accept]:
  \u0000-` -> 5
  b-\uffff -> 5
  a -> 4
state 1 [reject]:
  \u0000-\uffff -> 5
state 2 [accept]:
  u-\uffff -> 5
  t -> 6
  \u0000-s -> 5
state 3 [accept]:
  p -> 2
  q-\uffff -> 5
  \u0000-o -> 5
state 4 [accept]:
  \u0000-b -> 5
  d-\uffff -> 5
  c -> 7
state 5 [accept]:
  \u0000-\uffff -> 5
state 6 [accept]:
  s-\uffff -> 5
  \u0000-q -> 5
  r -> 0
state 7 [accept]:
  l-\uffff -> 5
  k -> 8
  \u0000-j -> 5
state 8 [accept]:
  = -> 1
  \u0000-< -> 5
  >-\uffff -> 5
};

