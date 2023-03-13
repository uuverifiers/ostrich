;test regex (?:[a-z0-9]+\.){2,}com
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "."))) ((_ re.loop 2 2) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".")))) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)