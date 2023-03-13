(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Ewebcruiser\x2Eccgot
(assert (str.in_re X (str.to_re "www.webcruiser.ccgot\u{0a}")))
; ^\d{5}-\d{4}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
