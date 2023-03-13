(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0])([1])([1,2,3,4,6,7,8,9])([0-9][0-9][0-9][0-9][0-9][0-9][0-9])
(assert (not (str.in_re X (re.++ (str.to_re "01") (re.union (str.to_re "1") (str.to_re ",") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9")) (str.to_re "\u{0a}") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9")))))
; ProjectHost\x3AlogHost\x3Awww\x2Esnap\x2EcomGoogle-\>rtServidor\x2E
(assert (str.in_re X (str.to_re "ProjectHost:logHost:www.snap.comGoogle->rtServidor.\u{13}\u{0a}")))
; ^[a-zA-Z0-9!@#$&_]+$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "!") (str.to_re "@") (str.to_re "#") (str.to_re "$") (str.to_re "&") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; ((EE|EL|DE|PT)-?)?[0-9]{9}
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "EE") (str.to_re "EL") (str.to_re "DE") (str.to_re "PT")) (re.opt (str.to_re "-")))) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /^\/[a-f0-9]{8}\/[a-f0-9]{7,8}\/$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 7 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "//U\u{0a}")))))
(check-sat)
