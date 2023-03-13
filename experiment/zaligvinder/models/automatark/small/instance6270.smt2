(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{2,6}-\d{2}-\d$
(assert (str.in_re X (re.++ ((_ re.loop 2 6) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}"))))
; [A-Za-z_.0-9-]+@{1}[a-z]+([.]{1}[a-z]{2,4})+
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re ".") (re.range "0" "9") (str.to_re "-"))) ((_ re.loop 1 1) (str.to_re "@")) (re.+ (re.range "a" "z")) (re.+ (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 4) (re.range "a" "z")))) (str.to_re "\u{0a}")))))
; ^((0[0-9])|(1[0-2])|(2[1-9])|(3[0-2])|(6[1-9])|(7[0-2])|80)([0-9]{7})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (str.to_re "2") (re.range "1" "9")) (re.++ (str.to_re "3") (re.range "0" "2")) (re.++ (str.to_re "6") (re.range "1" "9")) (re.++ (str.to_re "7") (re.range "0" "2")) (str.to_re "80")) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
