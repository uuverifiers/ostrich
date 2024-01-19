(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}otf([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.otf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^(102[0-3]|10[0-1]\d|[1-9][0-9]{0,2}|0)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "102") (re.range "0" "3")) (re.++ (str.to_re "10") (re.range "0" "1") (re.range "0" "9")) (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9"))) (str.to_re "0")) (str.to_re "\u{0a}")))))
; /^([a-zA-Z0-9])(([\-.]|[_]+)?([a-zA-Z0-9]+))*(@){1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (re.* (re.++ (re.opt (re.union (re.+ (str.to_re "_")) (str.to_re "-") (str.to_re "."))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) ((_ re.loop 1 1) (str.to_re "@")) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 1 1) (str.to_re ".")) (re.union ((_ re.loop 2 3) (re.range "a" "z")) (re.++ ((_ re.loop 2 3) (re.range "a" "z")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 3) (re.range "a" "z")))) (str.to_re "/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
