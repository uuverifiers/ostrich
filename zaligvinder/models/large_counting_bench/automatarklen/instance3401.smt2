(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/\?[a-z0-9]{2}\=[a-z1-9]{100}/siU
(assert (str.in_re X (re.++ (str.to_re "//?") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 100 100) (re.union (re.range "a" "z") (re.range "1" "9"))) (str.to_re "/siU\u{0a}"))))
; ^-?([1-8]?[1-9]|[1-9]0)\.{1}\d{1,6}
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.opt (re.range "1" "8")) (re.range "1" "9")) (re.++ (re.range "1" "9") (str.to_re "0"))) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^\d{4,4}[A-Z0-9]$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.union (re.range "A" "Z") (re.range "0" "9")) (str.to_re "\u{0a}")))))
; User-Agent\x3A\s+\x7D\x7BPassword\x3AAnal
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "}{Password:\u{1b}Anal\u{0a}"))))
; (0[1-9]|[12][0-9]|3[01])\s(J(anuary|uly)|Ma(rch|y)|August|(Octo|Decem)ber)\s[1-9][0-9]{3}|
(assert (str.in_re X (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ (str.to_re "J") (re.union (str.to_re "anuary") (str.to_re "uly"))) (re.++ (str.to_re "Ma") (re.union (str.to_re "rch") (str.to_re "y"))) (str.to_re "August") (re.++ (re.union (str.to_re "Octo") (str.to_re "Decem")) (str.to_re "ber"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
