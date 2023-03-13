(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9a-zA-Z]+[-._+&])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}$
(assert (not (str.in_re X (re.++ (re.* (re.++ (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (re.union (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "+") (str.to_re "&")))) (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "@") (re.+ (re.++ (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "."))) ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; /ID3\u{03}\u{00}.{5}([TW][A-Z]{3}|COMM)/smi
(assert (str.in_re X (re.++ (str.to_re "/ID3\u{03}\u{00}") ((_ re.loop 5 5) re.allchar) (re.union (re.++ (re.union (str.to_re "T") (str.to_re "W")) ((_ re.loop 3 3) (re.range "A" "Z"))) (str.to_re "COMM")) (str.to_re "/smi\u{0a}"))))
; ^((1[1-9]|2[03489]|3[0347]|5[56]|7[04-9]|8[047]|9[018])\d{8}|(1[2-9]\d|[58]00)\d{6}|8(001111|45464\d))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "1") (re.range "1" "9")) (re.++ (str.to_re "2") (re.union (str.to_re "0") (str.to_re "3") (str.to_re "4") (str.to_re "8") (str.to_re "9"))) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "3") (str.to_re "4") (str.to_re "7"))) (re.++ (str.to_re "5") (re.union (str.to_re "5") (str.to_re "6"))) (re.++ (str.to_re "7") (re.union (str.to_re "0") (re.range "4" "9"))) (re.++ (str.to_re "8") (re.union (str.to_re "0") (str.to_re "4") (str.to_re "7"))) (re.++ (str.to_re "9") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "8")))) ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ (re.union (re.++ (str.to_re "1") (re.range "2" "9") (re.range "0" "9")) (re.++ (re.union (str.to_re "5") (str.to_re "8")) (str.to_re "00"))) ((_ re.loop 6 6) (re.range "0" "9"))) (re.++ (str.to_re "8") (re.union (str.to_re "001111") (re.++ (str.to_re "45464") (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; \x2Fbar_pl\x2Fb\.fcgiHost\x3AHost\x3AClass\x2Ftoolbar\x2Fico\x2FGoogleLogsencoderserver
(assert (not (str.in_re X (str.to_re "/bar_pl/b.fcgiHost:Host:Class/toolbar/ico/GoogleLogsencoderserver\u{0a}"))))
; ^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
(check-sat)
