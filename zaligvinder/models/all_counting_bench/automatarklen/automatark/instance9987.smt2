(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((0[1-9]|1[0-9]|2[0-4])[0-59]\\d{7}(00[1-9]|[0-9][1-9][0-9]|[1-9][0-9][0-9]))|((0[1-9]|1[0-9]|2[0-4])6\\d{6}(000[1-9]|[0-9][0-9][1-9][0-9]|[0-9][1-9][0-9][0-9]|[1-9][0-9][0-9][0-9]))$
(assert (str.in_re X (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4"))) (re.union (re.range "0" "5") (str.to_re "9")) (str.to_re "\u{5c}") ((_ re.loop 7 7) (str.to_re "d")) (re.union (re.++ (str.to_re "00") (re.range "1" "9")) (re.++ (re.range "0" "9") (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "9") (re.range "0" "9") (re.range "0" "9")))) (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4"))) (str.to_re "6\u{5c}") ((_ re.loop 6 6) (str.to_re "d")) (re.union (re.++ (str.to_re "000") (re.range "1" "9")) (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "0" "9") (re.range "1" "9") (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "1" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9")))))))
; Pass-On\w+c\.goclick\.comletter
(assert (not (str.in_re X (re.++ (str.to_re "Pass-On") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "c.goclick.comletter\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
