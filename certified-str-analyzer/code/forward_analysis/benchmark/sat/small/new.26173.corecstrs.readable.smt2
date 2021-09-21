
var_0xINPUT_178847 := concat(T0_2, T1_2);

T0_2 in {
initial state: 0
state 0 [accept]:
};

T1_2 in {
initial state: 4
state 0 [accept]:
  \u0000-` -> 8
  b-\uffff -> 8
  a -> 5
state 1 [accept]:
  = -> 2
  \u0000-< -> 8
  >-\uffff -> 8
state 2 [reject]:
  \u0000-\uffff -> 8
state 3 [accept]:
  t -> 6
  u-\uffff -> 8
  \u0000-s -> 8
state 4 [accept]:
  p -> 3
  q-\uffff -> 8
  \u0000-o -> 8
state 5 [accept]:
  \u0000-b -> 8
  d-\uffff -> 8
  c -> 7
state 6 [accept]:
  s-\uffff -> 8
  \u0000-q -> 8
  r -> 0
state 7 [accept]:
  l-\uffff -> 8
  k -> 9
  \u0000-j -> 8
state 8 [accept]:
  \u0000-\uffff -> 8
state 9 [accept]:
  p -> 1
  q-\uffff -> 8
  \u0000-o -> 8
};

