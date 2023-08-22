(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3AHost\x3AFrom\u{3a}\u{03}\u{00}\u{1c}\u{00}\u{00}\u{00}\u{00}\u{00}\u{01}Furaxbnymomspyo\u{2f}zowy
(assert (str.in_re X (str.to_re "Host:Host:From:\u{03}\u{00}\u{1c}\u{00}\u{00}\u{00}\u{00}\u{00}\u{01}Furaxbnymomspyo/zowy\u{0a}")))
; ^[1-9][0-9]{3}$
(assert (not (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^(([\w][\w\-\.]*)\.)?([\w][\w\-]+)(\.([\w][\w\.]*))?$
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re ".") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* (re.union (str.to_re "-") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.opt (re.++ (str.to_re ".") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* (re.union (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "\u{0a}") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))
; /^\+?([0-9]{2})\)?[-. ]?([0-9]{4})[-. ]?([0-9]{4})$/;
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.opt (str.to_re "+")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/;\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
