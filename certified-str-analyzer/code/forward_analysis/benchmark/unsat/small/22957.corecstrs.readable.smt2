const150 == "&utmn=530224344&utmcs=UTF-8&utmsr=1680x976&utmsc=24-bit&utmul=en-us&utmje=0&utmfl=-&utmdt=Ask%20A%20Word&utmhn=hostname&utmhid=1232635290&utmr=0&utmp=";
const201 == "http://www.google-analytics.com/__utm.gif?utmwv=1.3";
const207 == "&utmac=";
const217 == "UA-167675-3";
const222 == "&utmcc=";
const386 == "__utma%3D169413169.486764834.1266891608.1266891608.1266891608.1%3B%2B__utmz%3D169413169.1266891608.1.1.utmccn%3D(direct)%7Cutmcsr%3D(direct)%7Cutmcmd%3D(none)%3B%2B";

T_1 := concat(T1_20, T2_9);
T_2 := concat(const150, T_1);
T_3 := concat(const201, T_2);
T_4 := concat(T_3, const207);
T_5 := concat(T_4, const217);
T_9 := concat(T1_20, T2_20);
T_6 := concat(T_5, const222);
T_a := concat(const150, T_9);
T_7 := concat(T_6, const386);

T2_9 in {
initial state: 0
state 0 [reject]:
  ? -> 3
state 1 [reject]:
  g -> 2
state 2 [accept]:
state 3 [reject]:
  d -> 4
state 4 [reject]:
  = -> 5
state 5 [reject]:
  g -> 1
};

T2_20 in {
initial state: 0
state 0 [reject]:
  ? -> 3
state 1 [reject]:
  g -> 2
state 2 [accept]:
state 3 [reject]:
  d -> 4
state 4 [reject]:
  = -> 5
state 5 [reject]:
  g -> 1
};

