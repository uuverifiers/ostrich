const165 == "&utmn=972379544&utmcs=UTF-8&utmsr=1680x976&utmsc=24-bit&utmul=en-us&utmje=0&utmfl=-&utmcn=1&utmdt=Ask%20A%20Word&utmhn=www.askaword.com&utmhid=877665680&utmr=0&utmp=";
const216 == "http://www.google-analytics.com/__utm.gif?utmwv=1.3";
const222 == "&utmac=";
const232 == "UA-167675-3";
const237 == "&utmcc=";
const401 == "__utma%3D169413169.972379544.1266894152.1266894152.1266894152.1%3B%2B__utmz%3D169413169.1266894152.1.1.utmccn%3D(direct)%7Cutmcsr%3D(direct)%7Cutmcmd%3D(none)%3B%2B";

T_1 := concat(T1_9, T2_20);
T_2 := concat(const165, T_1);
T_3 := concat(const216, T_2);
T_4 := concat(T_3, const222);
T_5 := concat(T_4, const232);
T_9 := concat(T1_20, T2_20);
T_6 := concat(T_5, const237);
T_a := concat(const165, T_9);
T_7 := concat(T_6, const401);

T1_9 in {
initial state: 0
state 0 [reject]:
  / -> 6
state 1 [reject]:
  r -> 2
state 2 [reject]:
  c -> 3
state 3 [reject]:
  h -> 9
state 4 [reject]:
  s -> 7
state 5 [accept]:
state 6 [reject]:
  s -> 8
state 7 [reject]:
  p -> 5
state 8 [reject]:
  e -> 10
state 9 [reject]:
  . -> 11
state 10 [reject]:
  a -> 1
state 11 [reject]:
  j -> 4
};

T1_20 in {
initial state: 0
state 0 [reject]:
  / -> 6
state 1 [reject]:
  r -> 2
state 2 [reject]:
  c -> 3
state 3 [reject]:
  h -> 9
state 4 [reject]:
  s -> 7
state 5 [accept]:
state 6 [reject]:
  s -> 8
state 7 [reject]:
  p -> 5
state 8 [reject]:
  e -> 10
state 9 [reject]:
  . -> 11
state 10 [reject]:
  a -> 1
state 11 [reject]:
  j -> 4
};

