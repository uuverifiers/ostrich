;test regex (?:[a-zA-Z]+)?([aeiou]{2,3}[a-zA-Z]+)/g
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.+ (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (re.++ ((_ re.loop 2 3) (re.union (str.to_re "a") (re.union (str.to_re "e") (re.union (str.to_re "i") (re.union (str.to_re "o") (str.to_re "u")))))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (str.to_re "/") (str.to_re "g"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)