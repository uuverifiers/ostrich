(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([a-zA-Z]:)|((\\|/){1,2}\w+)\$?)((\\|/)(\w[\w ]*.*))+\.([a-zA-Z0-9]+)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":")) (re.++ (re.opt (str.to_re "$")) ((_ re.loop 1 2) (re.union (str.to_re "\u{5c}") (str.to_re "/"))) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.+ (re.++ (re.union (str.to_re "\u{5c}") (str.to_re "/")) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* re.allchar))) (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)