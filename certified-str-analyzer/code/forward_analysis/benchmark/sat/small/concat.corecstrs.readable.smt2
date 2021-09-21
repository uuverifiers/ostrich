
PCTEMP_LHS_1 := concat(T1_2, T2_2);
T_2 := concat(PCTEMP_LHS_1, T2_6);

T_2 in {
initial state: 12
state 0 [reject]:
  o -> 14
state 1 [reject]:
  J -> 0
state 2 [reject]:
  e -> 15
state 3 [reject]:
  l -> 7
state 4 [reject]:
  n -> 3
state 5 [reject]:
  = -> 6
state 6 [reject]:
  O -> 4
state 7 [reject]:
  i -> 18
state 8 [reject]:
  l -> 9
state 9 [reject]:
  o -> 13
state 10 [reject]:
  e -> 19
state 11 [accept]:
state 12 [reject]:
  H -> 2
state 13 [reject]:
  = -> 1
state 14 [reject]:
  e -> 5
state 15 [reject]:
  l -> 8
state 16 [reject]:
  w -> 11
state 17 [reject]:
  o -> 16
state 18 [reject]:
  n -> 10
state 19 [reject]:
  N -> 17
};

T2_6 in {
initial state: 2
state 0 [accept]:
state 1 [reject]:
  o -> 3
state 2 [reject]:
  N -> 1
state 3 [reject]:
  w -> 0
};

T2_2 in {
initial state: 7
state 0 [reject]:
  n -> 2
state 1 [reject]:
  O -> 5
state 2 [reject]:
  e -> 4
state 3 [reject]:
  i -> 0
state 4 [accept]:
state 5 [reject]:
  n -> 6
state 6 [reject]:
  l -> 3
state 7 [reject]:
  = -> 1
};

