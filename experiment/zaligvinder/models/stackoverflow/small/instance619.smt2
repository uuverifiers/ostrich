;test regex (?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,}))
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "\u{00a1}" "\u{ffff0}") (re.union (str.to_re "-") (str.to_re "9"))))) (re.opt (str.to_re "-")))) (re.+ (re.union (re.range "a" "z") (re.union (re.range "\u{00a1}" "\u{ffff0}") (re.union (str.to_re "-") (str.to_re "9")))))) (re.++ (re.* (re.++ (str.to_re ".") (re.++ (re.* (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "\u{00a1}" "\u{ffff0}") (re.union (str.to_re "-") (str.to_re "9"))))) (re.opt (str.to_re "-")))) (re.+ (re.union (re.range "a" "z") (re.union (re.range "\u{00a1}" "\u{ffff0}") (re.union (str.to_re "-") (str.to_re "9")))))))) (re.++ (str.to_re ".") (re.++ (re.* (re.union (re.range "a" "z") (re.range "\u{00a1}" "\u{ffff}"))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "\u{00a1}" "\u{ffff}")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)