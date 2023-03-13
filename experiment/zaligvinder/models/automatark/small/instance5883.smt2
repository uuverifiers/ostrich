(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([A-HJ-PR-Y]{2}([0][1-9]|[1-9][0-9])|[A-HJ-PR-Y]{1}([1-9]|[1-2][0-9]|30|31|33|40|44|55|50|60|66|70|77|80|88|90|99|111|121|123|222|321|333|444|555|666|777|888|999|100|200|300|400|500|600|700|800|900))[ ][A-HJ-PR-Z]{3}$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "H") (re.range "J" "P") (re.range "R" "Y"))) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "9") (re.range "0" "9")))) (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "H") (re.range "J" "P") (re.range "R" "Y"))) (re.union (re.range "1" "9") (re.++ (re.range "1" "2") (re.range "0" "9")) (str.to_re "30") (str.to_re "31") (str.to_re "33") (str.to_re "40") (str.to_re "44") (str.to_re "55") (str.to_re "50") (str.to_re "60") (str.to_re "66") (str.to_re "70") (str.to_re "77") (str.to_re "80") (str.to_re "88") (str.to_re "90") (str.to_re "99") (str.to_re "111") (str.to_re "121") (str.to_re "123") (str.to_re "222") (str.to_re "321") (str.to_re "333") (str.to_re "444") (str.to_re "555") (str.to_re "666") (str.to_re "777") (str.to_re "888") (str.to_re "999") (str.to_re "100") (str.to_re "200") (str.to_re "300") (str.to_re "400") (str.to_re "500") (str.to_re "600") (str.to_re "700") (str.to_re "800") (str.to_re "900")))) (str.to_re " ") ((_ re.loop 3 3) (re.union (re.range "A" "H") (re.range "J" "P") (re.range "R" "Z"))) (str.to_re "\u{0a}")))))
; downloadfile\u{2e}org\w+com\x3EHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "downloadfile.org") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "com>Host:\u{0a}")))))
; SSKCstech\x2Eweb-nexus\x2Enet
(assert (str.in_re X (str.to_re "SSKCstech.web-nexus.net\u{0a}")))
; /\u{2e}pif([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.pif") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^[a-zA-Z0-9._\-]+@[a-z0-9\-]+(\.[a-z]+){1,}$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.+ (re.++ (str.to_re ".") (re.+ (re.range "a" "z")))) (str.to_re "\u{0a}"))))
(check-sat)
