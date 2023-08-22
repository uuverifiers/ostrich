(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(01)[0-9]{8}
(assert (str.in_re X (re.++ (str.to_re "01") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^(([1-9])|(0[1-9])|(1[0-2]))\/((0[1-9])|([1-31]))\/((\d{2})|(\d{4}))$
(assert (not (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.range "1" "3") (str.to_re "1")) (str.to_re "/") (re.union ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^((1[1-9]|2[03489]|3[0347]|5[56]|7[04-9]|8[047]|9[018])\d{8}|(1[2-9]\d|[58]00)\d{6}|8(001111|45464\d))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "1") (re.range "1" "9")) (re.++ (str.to_re "2") (re.union (str.to_re "0") (str.to_re "3") (str.to_re "4") (str.to_re "8") (str.to_re "9"))) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "3") (str.to_re "4") (str.to_re "7"))) (re.++ (str.to_re "5") (re.union (str.to_re "5") (str.to_re "6"))) (re.++ (str.to_re "7") (re.union (str.to_re "0") (re.range "4" "9"))) (re.++ (str.to_re "8") (re.union (str.to_re "0") (str.to_re "4") (str.to_re "7"))) (re.++ (str.to_re "9") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "8")))) ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ (re.union (re.++ (str.to_re "1") (re.range "2" "9") (re.range "0" "9")) (re.++ (re.union (str.to_re "5") (str.to_re "8")) (str.to_re "00"))) ((_ re.loop 6 6) (re.range "0" "9"))) (re.++ (str.to_re "8") (re.union (str.to_re "001111") (re.++ (str.to_re "45464") (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; SbAts\d+dcww\x2Edmcast\x2EcomdistID=
(assert (not (str.in_re X (re.++ (str.to_re "SbAts") (re.+ (re.range "0" "9")) (str.to_re "dcww.dmcast.comdistID=\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
