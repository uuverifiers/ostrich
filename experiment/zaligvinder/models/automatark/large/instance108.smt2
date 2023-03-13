(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^id\u{3d}[A-F\d]{32}(\u{26}info\u{3d}[A-F\d]{24})?$/P
(assert (not (str.in_re X (re.++ (str.to_re "/id=") ((_ re.loop 32 32) (re.union (re.range "A" "F") (re.range "0" "9"))) (re.opt (re.++ (str.to_re "&info=") ((_ re.loop 24 24) (re.union (re.range "A" "F") (re.range "0" "9"))))) (str.to_re "/P\u{0a}")))))
(check-sat)
