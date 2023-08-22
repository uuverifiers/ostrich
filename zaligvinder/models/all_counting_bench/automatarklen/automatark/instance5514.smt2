(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[^\\\/\?\*\"\'\>\<\:\|]*$
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re "\u{5c}") (str.to_re "/") (str.to_re "?") (str.to_re "*") (str.to_re "\u{22}") (str.to_re "'") (str.to_re ">") (str.to_re "<") (str.to_re ":") (str.to_re "|"))) (str.to_re "\u{0a}")))))
; ^[0-9]{2}[-][0-9]{2}[-][0-9]{2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
