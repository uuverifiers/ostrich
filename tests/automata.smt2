(declare-const x String)
(assert (= x "ab"))
(assert (str.in.re x (re.from_automaton "automaton value_0 {init s0; s0 -> s1 [0, 100]; s1 -> s1 [0, 65535];accepting s1;};")))
