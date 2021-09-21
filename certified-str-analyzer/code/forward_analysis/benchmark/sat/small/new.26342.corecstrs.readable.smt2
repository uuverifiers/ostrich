
var_0xINPUT_4637 := concat(T0_2, T1_2);

T0_2 in {
initial state: 0
state 0 [accept]:
};

T1_2 in {
initial state: 2
state 0 [accept]:
  u -> 5
  v-\uffff -> 6
  \u0000-t -> 6
state 1 [reject]:
  \u0000-\uffff -> 6
state 2 [accept]:
  \u0000-> -> 6
  ? -> 4
  @-\uffff -> 6
state 3 [accept]:
  e -> 7
  f-\uffff -> 6
  \u0000-d -> 6
state 4 [accept]:
  d -> 3
  e-\uffff -> 6
  \u0000-c -> 6
state 5 [accept]:
  \u0000-f -> 6
  g -> 8
  h-\uffff -> 6
state 6 [accept]:
  \u0000-\uffff -> 6
state 7 [accept]:
  c-\uffff -> 6
  \u0000-a -> 6
  b -> 0
state 8 [accept]:
  = -> 9
  \u0000-< -> 6
  >-\uffff -> 6
state 9 [accept]:
  \u0000-0 -> 6
  2-\uffff -> 6
  1 -> 1
};

