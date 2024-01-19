(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[\\(]{0,1}([0-9]){3}[\\)]{0,1}[ ]?([^0-1]){1}([0-9]){2}[ ]?[-]?[ ]?([0-9]){4}[ ]*((x){0,1}([0-9]){1,5}){0,1}$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "\u{5c}") (str.to_re "("))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "\u{5c}") (str.to_re ")"))) (re.opt (str.to_re " ")) ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) (re.opt (str.to_re "-")) (re.opt (str.to_re " ")) ((_ re.loop 4 4) (re.range "0" "9")) (re.* (str.to_re " ")) (re.opt (re.++ (re.opt (str.to_re "x")) ((_ re.loop 1 5) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
