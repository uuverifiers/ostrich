(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /u=[\dA-Fa-f]{8}/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/u=") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f"))) (str.to_re "/smiU\u{0a}")))))
(check-sat)
