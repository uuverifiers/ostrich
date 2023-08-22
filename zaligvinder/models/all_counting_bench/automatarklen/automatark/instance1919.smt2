(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([1-9]?\d|1\d\d|2[0-4]\d|25[0-5]).){3}([1-9]?\d|1\d\d|2[0-4]\d|25[0-5])$
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.++ (re.union (re.++ (re.opt (re.range "1" "9")) (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) re.allchar)) (re.union (re.++ (re.opt (re.range "1" "9")) (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re "\u{0a}"))))
; /\u{2e}webm([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.webm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /^\/\d{4}\/\d{7}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
