(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[2-9]\d{2}-\d{3}-\d{4}$
(assert (not (str.in_re X (re.++ (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename\=[a-z0-9]{24}\.jar/H
(assert (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 24 24) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".jar/H\u{0a}"))))
; www\x2Erichfind\x2Ecom\d+UI2
(assert (str.in_re X (re.++ (str.to_re "www.richfind.com") (re.+ (re.range "0" "9")) (str.to_re "UI2\u{0a}"))))
; /^[-+]?[1-9](\d*|((\d{1,2})?,(\d{3},)*(\d{3})))?([eE][-+]\d+)?$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.range "1" "9") (re.opt (re.union (re.* (re.range "0" "9")) (re.++ (re.opt ((_ re.loop 1 2) (re.range "0" "9"))) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))))) (re.opt (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.union (str.to_re "-") (str.to_re "+")) (re.+ (re.range "0" "9")))) (str.to_re "/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
