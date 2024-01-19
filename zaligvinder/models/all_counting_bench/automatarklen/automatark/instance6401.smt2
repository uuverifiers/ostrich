(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\{?[a-fA-F\d]{8}-([a-fA-F\d]{4}-){3}[a-fA-F\d]{12}\}?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "{")) ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 3 3) (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-"))) ((_ re.loop 12 12) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (re.opt (str.to_re "}")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
