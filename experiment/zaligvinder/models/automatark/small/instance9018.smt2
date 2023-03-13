(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z][a-z]+(o(i|u)(n|(v)?r(t)?|s|t|x)(e(s)?)?)$
(assert (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.range "a" "z")) (str.to_re "\u{0a}o") (re.union (str.to_re "i") (str.to_re "u")) (re.union (str.to_re "n") (re.++ (re.opt (str.to_re "v")) (str.to_re "r") (re.opt (str.to_re "t"))) (str.to_re "s") (str.to_re "t") (str.to_re "x")) (re.opt (re.++ (str.to_re "e") (re.opt (str.to_re "s")))))))
; \x7D\x7BTrojan\x3A\w+Host\x3A\s\d\x2El
(assert (str.in_re X (re.++ (str.to_re "}{Trojan:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.range "0" "9") (str.to_re ".l\u{0a}"))))
; username=(.*)&password=(.*)
(assert (str.in_re X (re.++ (str.to_re "username=") (re.* re.allchar) (str.to_re "&password=") (re.* re.allchar) (str.to_re "\u{0a}"))))
; bind\w+Owner\x3A\dBetaWordixqshv\u{2f}qzccs
(assert (not (str.in_re X (re.++ (str.to_re "bind") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:") (re.range "0" "9") (str.to_re "BetaWordixqshv/qzccs\u{0a}")))))
; 0{3,}|1{3,}|2{3,}|3{3,}|4{3,}|5{3,}|6{3,}|7{3,}|8{3,}|9{3,}
(assert (str.in_re X (re.union (re.++ ((_ re.loop 3 3) (str.to_re "0")) (re.* (str.to_re "0"))) (re.++ ((_ re.loop 3 3) (str.to_re "1")) (re.* (str.to_re "1"))) (re.++ ((_ re.loop 3 3) (str.to_re "2")) (re.* (str.to_re "2"))) (re.++ ((_ re.loop 3 3) (str.to_re "3")) (re.* (str.to_re "3"))) (re.++ ((_ re.loop 3 3) (str.to_re "4")) (re.* (str.to_re "4"))) (re.++ ((_ re.loop 3 3) (str.to_re "5")) (re.* (str.to_re "5"))) (re.++ ((_ re.loop 3 3) (str.to_re "6")) (re.* (str.to_re "6"))) (re.++ ((_ re.loop 3 3) (str.to_re "7")) (re.* (str.to_re "7"))) (re.++ ((_ re.loop 3 3) (str.to_re "8")) (re.* (str.to_re "8"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (str.to_re "9")) (re.* (str.to_re "9"))))))
(check-sat)
