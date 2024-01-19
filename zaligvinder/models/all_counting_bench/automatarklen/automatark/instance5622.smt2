(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^0[87][23467]((\d{7})|( |-)((\d{3}))( |-)(\d{4})|( |-)(\d{7})))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}0") (re.union (str.to_re "8") (str.to_re "7")) (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "6") (str.to_re "7")) (re.union ((_ re.loop 7 7) (re.range "0" "9")) (re.++ (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9"))))))))
; ^((\d{1,3}(,\d{3})*)|(\d{1,3}))$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
