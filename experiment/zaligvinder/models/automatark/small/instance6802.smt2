(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-Z]{5})([a-zA-Z0-9-]{3,12})
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 3 12) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re "\u{0a}"))))
; Host\x3A\w+wwwfromToolbartheServer\x3Awww\x2Esearchreslt\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "wwwfromToolbartheServer:www.searchreslt.com\u{0a}")))))
; (^0?[1-9]|^1[0-2])\/(0?[1-9]|[1-2][0-9]|3[0-1])\/(19|20)?[0-9][0-9](\s(((0?[0-9]|1[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?)|((0?[0-9]|1[0-2]):[0-5][0-9](:[0-5][0-9])?\s(AM|PM))))?$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.opt (re.union (str.to_re "19") (str.to_re "20"))) (re.range "0" "9") (re.range "0" "9") (re.opt (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9") (re.opt (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9")))) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9") (re.opt (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (str.to_re "AM") (str.to_re "PM")))))) (str.to_re "\u{0a}"))))
; asdbiz\x2Ebiz\s+informationHost\x3A
(assert (str.in_re X (re.++ (str.to_re "asdbiz.biz") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "informationHost:\u{0a}"))))
; Subject\x3ALOGX-Mailer\u{3a}
(assert (not (str.in_re X (str.to_re "Subject:LOGX-Mailer:\u{13}\u{0a}"))))
(check-sat)
