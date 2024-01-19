(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{2}([0][1-9]|[1][0-2])([0][1-9]|[1-2][0-9]|[3][0-1])-\d{4}$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}ppsx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ppsx/i\u{0a}")))))
; OSSProxyHost\x3ASubject\u{3a}s_sq=aolsnssignin
(assert (str.in_re X (str.to_re "OSSProxyHost:Subject:s_sq=aolsnssignin\u{0a}")))
; (^\d{5}-\d{3}|^\d{2}.\d{3}-\d{3}|\d{8})
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9"))) ((_ re.loop 8 8) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; (^(5[0678])\d{11,18}$)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 11 18) (re.range "0" "9")) (str.to_re "5") (re.union (str.to_re "0") (str.to_re "6") (str.to_re "7") (str.to_re "8")))))
(assert (> (str.len X) 10))
(check-sat)
