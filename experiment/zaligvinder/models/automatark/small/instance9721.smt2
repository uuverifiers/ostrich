(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\$?([A-Za-z]{0,2})\$?([0-9]{0,5}):?\$?([A-Za-z]{0,2})\$?([0-9]{0,5})$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) ((_ re.loop 0 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re "$")) ((_ re.loop 0 5) (re.range "0" "9")) (re.opt (str.to_re ":")) (re.opt (str.to_re "$")) ((_ re.loop 0 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re "$")) ((_ re.loop 0 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
