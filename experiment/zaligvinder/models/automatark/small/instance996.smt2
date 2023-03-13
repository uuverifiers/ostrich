(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\{?[a-fA-F\d]{32}\}?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "{")) ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (re.opt (str.to_re "}")) (str.to_re "\u{0a}")))))
(check-sat)
