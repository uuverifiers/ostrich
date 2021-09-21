const159 == "&utmn=1312973922&utmcs=UTF-8&utmsr=1680x976&utmsc=24-bit&utmul=en-us&utmje=0&utmfl=-&utmdt=Ask%20A%20Word&utmhn=www.askaword.com&utmhid=1753185562&utmr=0&utmp=";
const210 == "http://www.google-analytics.com/__utm.gif?utmwv=1.3";
const216 == "&utmac=";
const226 == "UA-167675-3";
const231 == "&utmcc=";
const396 == "__utma%3D169413169.1480669353.1266928609.1266928609.1266928609.1%3B%2B__utmz%3D169413169.1266928609.1.1.utmccn%3D(direct)%7Cutmcsr%3D(direct)%7Cutmcmd%3D(none)%3B%2B";

T_1 := concat(T1_20, T2_9);
T_2 := concat(const159, T_1);
T_3 := concat(const210, T_2);
T_4 := concat(T_3, const216);
T_5 := concat(T_4, const226);
T_9 := concat(T1_20, T2_20);
T_6 := concat(T_5, const231);
T_a := concat(const159, T_9);
T_7 := concat(T_6, const396);

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

