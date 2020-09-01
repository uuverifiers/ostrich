(set-logic QF_S)

(declare-const w String)

(assert (str.in.re w (re.from.str "[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*")))

(assert (str.prefixof "me@" w))
(assert (str.suffixof "@gmail.com" w))

(check-sat)
