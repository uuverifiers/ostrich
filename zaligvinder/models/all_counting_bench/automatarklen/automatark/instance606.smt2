(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Z]{0,3})?[ ]?([0-9]{1,3},([0-9]{3},)*[0-9]{3}|[0-9]+)(.[0-9][0-9])?$
(assert (str.in_re X (re.++ (re.opt ((_ re.loop 0 3) (re.range "A" "Z"))) (re.opt (str.to_re " ")) (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) (re.+ (re.range "0" "9"))) (re.opt (re.++ re.allchar (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
