(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^[a-zA-Z0-9]+://)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "://"))))
; /\/\d+\.mp3\?rnd=\d+$/U
(assert (str.in_re X (re.++ (str.to_re "//") (re.+ (re.range "0" "9")) (str.to_re ".mp3?rnd=") (re.+ (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
; ^[^\\\/\?\*\"\'\>\<\:\|]*$
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re "\u{5c}") (str.to_re "/") (str.to_re "?") (str.to_re "*") (str.to_re "\u{22}") (str.to_re "'") (str.to_re ">") (str.to_re "<") (str.to_re ":") (str.to_re "|"))) (str.to_re "\u{0a}")))))
; ^[1-9]{1}$|^[0-9]{1}[0-9]{1}[0-9]{1}[0-9]{1}$|^9999$
(assert (str.in_re X (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (str.to_re "9999\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
