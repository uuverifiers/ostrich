(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^/{1}(((/{1}\.{1})?[a-zA-Z0-9 ]+/?)+(\.{1}[a-zA-Z0-9]{2,4})?)$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "/")) (str.to_re "\u{0a}") (re.+ (re.++ (re.opt (re.++ ((_ re.loop 1 1) (str.to_re "/")) ((_ re.loop 1 1) (str.to_re ".")))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re " "))) (re.opt (str.to_re "/")))) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))))))))
(assert (> (str.len X) 10))
(check-sat)
