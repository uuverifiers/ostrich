(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{1,8}$|^\d{1,3},\d{3}$|^\d{1,2},\d{3},\d{3}$
(assert (str.in_re X (re.union ((_ re.loop 1 8) (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
