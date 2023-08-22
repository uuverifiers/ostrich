(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([0]{0,1})([1-9]{1})([0-9]{2})){1}([\ ]{0,1})((([0-9]{3})([\ ]{0,1})([0-9]{3}))|(([0-9]{2})([\ ]{0,1})([0-9]{2})([\ ]{0,1})([0-9]{2})))$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.++ (re.opt (str.to_re "0")) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.opt (str.to_re " ")) (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
