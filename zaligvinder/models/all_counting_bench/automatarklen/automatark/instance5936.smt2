(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([1-4][0-9])|(0[1-9])|(5[0-2]))\/[1-2]\d{3}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.range "1" "4") (re.range "0" "9")) (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "5") (re.range "0" "2"))) (str.to_re "/") (re.range "1" "2") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ("((\\.)|[^\\"])*")
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}\u{22}") (re.* (re.union (re.++ (str.to_re "\u{5c}") re.allchar) (str.to_re "\u{5c}") (str.to_re "\u{22}"))) (str.to_re "\u{22}")))))
(assert (> (str.len X) 10))
(check-sat)
