(set-logic QF_SLIA)

(declare-const w String)

(assert (str.in_re w (re.range "ab" "c")))

(check-sat)
