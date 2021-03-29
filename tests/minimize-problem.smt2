; Example that tends to time out when trying to minimize/determinize automata

(declare-const w String)
(assert (str.in.re w (re.from_ecma2020 "^.+@.+\\..{2,20}$")))

(assert (str.in.re w (re.* (re.range "\u{20}" "\u{FFFF}"))))

(check-sat)
