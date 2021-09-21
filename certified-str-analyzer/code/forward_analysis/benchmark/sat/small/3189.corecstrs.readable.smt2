
T_5 := concat(T1_8, PCTEMP_LHS_1);

T1_8 in {
initial state: 0
state 0 [reject]:
  s -> 7
state 1 [accept]:
state 2 [reject]:
  b -> 6
state 3 [reject]:
  i -> 4
state 4 [reject]:
  b -> 5
state 5 [reject]:
  e -> 10
state 6 [reject]:
  s -> 8
state 7 [reject]:
  u -> 2
state 8 [reject]:
  c -> 9
state 9 [reject]:
  r -> 3
state 10 [reject]:
  = -> 1
};

PCTEMP_LHS_1 in {
initial state: 0
state 0 [accept]:
  % -> 1
  &-\uffff -> 2
  \u0000-$ -> 2
state 1 [reject]:
  \u0000-\uffff -> 2
state 2 [accept]:
  \u0000-\uffff -> 2
};

PCTEMP_LHS_1 in {
initial state: 4
state 0 [reject]:
  \u0000-\uffff -> 2
state 1 [accept]:
  s-\uffff -> 2
  \u0000-q -> 2
  r -> 3
state 2 [accept]:
  \u0000-\uffff -> 2
state 3 [accept]:
  s-\uffff -> 2
  \u0000-q -> 2
  r -> 5
state 4 [accept]:
  \u0000-` -> 2
  b-\uffff -> 2
  a -> 1
state 5 [accept]:
  \u0000-` -> 2
  b-\uffff -> 2
  a -> 6
state 6 [accept]:
  z-\uffff -> 2
  \u0000-x -> 2
  y -> 0
};

PCTEMP_LHS_1 in {
initial state: 1
state 0 [accept]:
  \u0000-\uffff -> 0
state 1 [reject]:
  \u0000-\uffff -> 0
};

