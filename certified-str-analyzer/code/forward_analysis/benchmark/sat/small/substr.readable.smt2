
T2_2 := concat(PCTEMP_LHS_1, T3_2);
var_0xINPUT_2 := concat(T1_2, T2_2);

T1_2 in {
initial state: 0
state 0 [accept]:
};

PCTEMP_LHS_1 in {
initial state: 6
state 0 [accept]:
  \u0000-k -> 4
  m-\uffff -> 4
  l -> 1
state 1 [accept]:
  \u0000-k -> 4
  m-\uffff -> 4
  l -> 5
state 2 [reject]:
  \u0000-\uffff -> 4
state 3 [accept]:
  e -> 0
  f-\uffff -> 4
  \u0000-d -> 4
state 4 [accept]:
  \u0000-\uffff -> 4
state 5 [accept]:
  \u0000-n -> 4
  o -> 2
  p-\uffff -> 4
state 6 [accept]:
  \u0000-g -> 4
  h -> 3
  i-\uffff -> 4
};

