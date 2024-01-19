(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\-)?1000([.][0]{1,3})?$|^(\-)?\d{1,3}$|^(\-)?\d{1,3}([.]\d{1,3})$|^(\-)?([.]\d{1,3})$
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "-")) (str.to_re "1000") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (str.to_re "0"))))) (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 3) (re.range "0" "9"))) (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))) (re.++ (re.opt (str.to_re "-")) (str.to_re "\u{0a}.") ((_ re.loop 1 3) (re.range "0" "9"))))))
; /[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{13}\u{28}\x0A\u{51}/
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 13 13) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "(\u{0a}Q/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
