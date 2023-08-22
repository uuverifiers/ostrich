(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\d+Subject\x3Aas\x2Estarware\x2Ecom\x2Fdp\x2Fsearch\?x=
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Subject:as.starware.com/dp/search?x=\u{0a}")))))
; ^[a-zA-Z0-9\_\-]+[a-zA-Z0-9\.\_\-]*@([a-zA-Z0-9\_\-]+\.)+([a-zA-Z]{2,4}|travel|museum)$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) (str.to_re "@") (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (str.to_re "."))) (re.union ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "travel") (str.to_re "museum")) (str.to_re "\u{0a}"))))
; ^((([0-9]|([0-1][0-9])|(2[0-3]))[hH:][0-5][0-9])|(([0-9]|(1[0-9])|(2[0-3]))[hH]))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.range "0" "9") (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.union (str.to_re "h") (str.to_re "H") (str.to_re ":")) (re.range "0" "5") (re.range "0" "9")) (re.++ (re.union (re.range "0" "9") (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.union (str.to_re "h") (str.to_re "H")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
