(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\.{0,2}[\/\\]
(assert (not (str.in_re X (re.++ ((_ re.loop 0 2) (str.to_re ".")) (re.union (str.to_re "/") (str.to_re "\u{5c}")) (str.to_re "\u{0a}")))))
(check-sat)
