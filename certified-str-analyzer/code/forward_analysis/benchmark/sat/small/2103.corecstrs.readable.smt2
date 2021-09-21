
var_0xINPUT_1380 := concat(T0_3, T1_3);

T0_3 in {
initial state: 0
state 0 [accept]:
};

var_0xINPUT_1380 in {
initial state: 1
state 0 [accept]:
  \u0000-\uffff -> 0
state 1 [reject]:
  \u0000-\uffff -> 0
};

T1_3 in {
initial state: 0
state 0 [accept]:
  \u0000-> -> 1
  ? -> 2
  @-\uffff -> 1
state 1 [accept]:
  \u0000-\uffff -> 1
state 2 [reject]:
  \u0000-\uffff -> 1
};

