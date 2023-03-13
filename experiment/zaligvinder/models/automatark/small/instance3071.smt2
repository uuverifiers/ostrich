(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([0-9a-z_-]+[\.][0-9a-z_-]{1,3})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (str.to_re "_") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 1 3) (re.union (re.range "0" "9") (re.range "a" "z") (str.to_re "_") (str.to_re "-"))))))
(check-sat)
