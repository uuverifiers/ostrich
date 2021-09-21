
P1_2 := concat(PCTEMP_LHS_1_idx_1, M1_2);
T1_2 := concat(P1_2, PCTEMP_LHS_1_idx_2);
P0_2 := concat(PCTEMP_LHS_1_idx_0, M0_2);
T0_2 := concat(P0_2, T1_2);

PCTEMP_LHS_1_idx_0 in {
initial state: 1
state 0 [reject]:
  l -> 5
state 1 [reject]:
  H -> 3
state 2 [reject]:
  l -> 0
state 3 [reject]:
  e -> 2
state 4 [accept]:
state 5 [reject]:
  o -> 4
};

M1_2 in {
initial state: 1
state 0 [accept]:
state 1 [reject]:
  = -> 0
};

M0_2 in {
initial state: 1
state 0 [accept]:
state 1 [reject]:
  = -> 0
};

PCTEMP_LHS_1_idx_1 in {
initial state: 1
state 0 [accept]:
  \u0000-\uffff -> 0
state 1 [accept]:
  = -> 2
  \u0000-< -> 0
  >-\uffff -> 0
state 2 [reject]:
  \u0000-\uffff -> 0
};

PCTEMP_LHS_1_idx_0 in {
initial state: 1
state 0 [accept]:
  \u0000-\uffff -> 0
state 1 [accept]:
  = -> 2
  \u0000-< -> 0
  >-\uffff -> 0
state 2 [reject]:
  \u0000-\uffff -> 0
};

