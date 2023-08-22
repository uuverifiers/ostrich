(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /hwinfo=\u{7b}[a-f0-9]{8}\u{2d}[a-f0-9]{4}\u{2d}[a-f0-9]{4}\u{2d}[a-f0-9]{4}\u{2d}[a-f0-9]{12}\u{7d}/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/hwinfo={") ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "}/smiU\u{0a}")))))
; ^[^\\\/\?\*\"\'\>\<\:\|]*$
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re "\u{5c}") (str.to_re "/") (str.to_re "?") (str.to_re "*") (str.to_re "\u{22}") (str.to_re "'") (str.to_re ">") (str.to_re "<") (str.to_re ":") (str.to_re "|"))) (str.to_re "\u{0a}")))))
; ^([987]{1})(\d{1})(\d{8})
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "9") (str.to_re "8") (str.to_re "7"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
