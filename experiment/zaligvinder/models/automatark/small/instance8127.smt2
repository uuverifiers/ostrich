(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[^-]{1}?[^\"\']*$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.comp (str.to_re "-"))) (re.* (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "\u{0a}")))))
(check-sat)
