(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((2|8|9)\d{2})|((02|08|09)\d{2})|([1-9]\d{3}))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "2") (str.to_re "8") (str.to_re "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "0") (re.union (str.to_re "2") (str.to_re "8") (str.to_re "9"))) (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /\u{2e}pif([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.pif") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
