(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[+]?100(\.0{1,2})?%?$|^[+]?\d{1,2}(\.\d{1,2})?%?$
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "+")) (str.to_re "100") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (str.to_re "0")))) (re.opt (str.to_re "%"))) (re.++ (re.opt (str.to_re "+")) ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (re.opt (str.to_re "%")) (str.to_re "\u{0a}")))))
; <[iI][mM][gG]([^>]*[^/>])
(assert (str.in_re X (re.++ (str.to_re "<") (re.union (str.to_re "i") (str.to_re "I")) (re.union (str.to_re "m") (str.to_re "M")) (re.union (str.to_re "g") (str.to_re "G")) (str.to_re "\u{0a}") (re.* (re.comp (str.to_re ">"))) (re.union (str.to_re "/") (str.to_re ">")))))
(check-sat)
