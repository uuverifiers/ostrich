(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}cis/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".cis/i\u{0a}")))))
; /^([A-Za-z0-9+\u{2f}]{4})*([A-Za-z0-9+\u{2f}]{4}|[A-Za-z0-9+\u{2f}]{3}=|[A-Za-z0-9+\u{2f}]{2}==)$/mP
(assert (str.in_re X (re.++ (str.to_re "/") (re.* ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/")))) (re.union ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) (str.to_re "=")) (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) (str.to_re "=="))) (str.to_re "/mP\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
