(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\$?(([1-9],)?([0-9]{3},){0,3}[0-9]{3}|[0-9]{0,16})(\.[0-9]{0,3})?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union (re.++ (re.opt (re.++ (re.range "1" "9") (str.to_re ","))) ((_ re.loop 0 3) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) ((_ re.loop 0 16) (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(check-sat)
