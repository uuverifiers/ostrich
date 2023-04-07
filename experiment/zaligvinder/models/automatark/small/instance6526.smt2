(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (LT-?)?([0-9]{9}|[0-9]{12})
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "LT") (re.opt (str.to_re "-")))) (re.union ((_ re.loop 9 9) (re.range "0" "9")) ((_ re.loop 12 12) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}mny/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mny/i\u{0a}")))))
(check-sat)