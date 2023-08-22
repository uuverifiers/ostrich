(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[a-z]=[a-f0-9]{98}/P
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.range "a" "z") (str.to_re "=") ((_ re.loop 98 98) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/P\u{0a}")))))
; /\u{2e}scr([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.scr") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^([a-z]{2,3}(\.[a-zA-Z][a-zA-Z_$0-9]*)*)\.([A-Z][a-zA-Z_$0-9]*)$
(assert (str.in_re X (re.++ (str.to_re ".\u{0a}") ((_ re.loop 2 3) (re.range "a" "z")) (re.* (re.++ (str.to_re ".") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re "$") (re.range "0" "9"))))) (re.range "A" "Z") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re "$") (re.range "0" "9"))))))
(assert (< 200 (str.len X)))
(check-sat)
