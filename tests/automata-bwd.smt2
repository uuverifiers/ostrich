(declare-const x String)
(declare-const y String)
;(assert (= x "bB"))
(assert(str.suffixof "B" x))

;(assert (str.in.re x (re.from_automaton "automaton value_0 {init s0; s0 -> s0 [0, 65];s0 -> s0 [68, 97];s0 -> s1 [98, 98];s0 -> s0 [99, 65535]; s1 -> s1 [0, 66];s1 -> s1 [68, 65535];accepting s0,s1;};")))
(assert (str.in.re x (re.from_automaton "automaton value_0 {init s0; s0 -> s0 [0, 66];s0 -> s0 [68, 65535];accepting s0;};")))

(assert(= y (str.replace x "B" "b")))
