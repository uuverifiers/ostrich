(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3})$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; /\/java(rh|db)\.php$/U
(assert (str.in_re X (re.++ (str.to_re "//java") (re.union (str.to_re "rh") (str.to_re "db")) (str.to_re ".php/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
