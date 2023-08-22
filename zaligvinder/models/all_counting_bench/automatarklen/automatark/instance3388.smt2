(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^
(assert (not (str.in_re X (str.to_re "\u{0a}"))))
; /\/AES\d+O\d+\.jsp\?[a-z0-9=\u{2b}\u{2f}]{20}/iU
(assert (str.in_re X (re.++ (str.to_re "//AES") (re.+ (re.range "0" "9")) (str.to_re "O") (re.+ (re.range "0" "9")) (str.to_re ".jsp?") ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "=") (str.to_re "+") (str.to_re "/"))) (str.to_re "/iU\u{0a}"))))
; ^(([0-1]?[1-9]|2[0-3])(:)([0-5][0-9]))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "1" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))))
; ^([A-Za-z]|[A-Za-z][0-9]*|[0-9]*[A-Za-z])+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.* (re.range "0" "9"))) (re.++ (re.* (re.range "0" "9")) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
