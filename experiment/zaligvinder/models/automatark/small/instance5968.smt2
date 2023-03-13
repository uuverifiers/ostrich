(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 2 2) (re.range "1" "9")) (re.++ (re.range "0" "9") (re.range "1" "9")) (re.++ (re.range "1" "9") (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /^dir=[0-9A-F]{8}(-[0-9A-F]{4}){4}[0-9A-F]{8}&data=/Pi
(assert (str.in_re X (re.++ (str.to_re "/dir=") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "F"))) ((_ re.loop 4 4) (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))))) ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "&data=/Pi\u{0a}"))))
; www\x2Eweepee\x2Ecom\w+Owner\x3Aiswww\x2Eemp3finder\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "www.weepee.com\u{1b}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:iswww.emp3finder.com\u{0a}")))))
; (^(\d+)$)|(^(\d{1,3}[ ,\.](\d{3}[ ,\.])*\d{3}|\d{1,3})$)
(assert (str.in_re X (re.union (re.+ (re.range "0" "9")) (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re ",") (str.to_re ".")) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re ",") (str.to_re ".")))) ((_ re.loop 3 3) (re.range "0" "9"))) ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
