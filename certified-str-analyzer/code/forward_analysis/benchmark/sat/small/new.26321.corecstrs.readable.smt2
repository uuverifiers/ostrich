
var_0xINPUT_15310 := concat(T0_2, T1_2);

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
  \u0000-^ -> 5
  _ -> 6
  `-\uffff -> 5
state 3 [accept]:
  \u0000-^ -> 5
  _ -> 2
  `-\uffff -> 5
state 4 [accept]:
  e-\uffff -> 5
  d -> 7
  \u0000-c -> 5
state 5 [accept]:
  \u0000-\uffff -> 5
state 6 [accept]:
  \u0000-f -> 5
  g -> 0
  h-\uffff -> 5
state 7 [accept]:
  \u0000-r -> 5
  t-\uffff -> 5
  s -> 8
state 8 [accept]:
  = -> 1
  \u0000-< -> 5
  >-\uffff -> 5
};

