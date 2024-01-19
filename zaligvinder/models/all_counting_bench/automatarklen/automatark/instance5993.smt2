(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{3f}sv\u{3d}\d{1,3}\u{26}tq\u{3d}/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/?sv=") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "&tq=/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
