(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}dbp/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dbp/i\u{0a}")))))
; ^.+@[^\.].*\.[a-z]{2,}$
(assert (str.in_re X (re.++ (re.+ re.allchar) (str.to_re "@") (re.comp (str.to_re ".")) (re.* re.allchar) (str.to_re ".\u{0a}") ((_ re.loop 2 2) (re.range "a" "z")) (re.* (re.range "a" "z")))))
; ^(0[1-9]|1[0-2])\/((0[1-9]|2\d)|3[0-1])\/(19\d\d|200[0-3])$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (str.to_re "3") (re.range "0" "1")) (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "2") (re.range "0" "9"))) (str.to_re "/") (re.union (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "200") (re.range "0" "3"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
