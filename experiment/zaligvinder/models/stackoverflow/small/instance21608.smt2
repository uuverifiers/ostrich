;test regex \A(((\+)(\d{2})?)|(00(\d{2})?)|)((\d|\s)+)\Z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (re.union (re.++ (str.to_re "") (re.union (re.++ (str.to_re "+") (re.opt ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "00") (re.opt ((_ re.loop 2 2) (re.range "0" "9")))))) (str.to_re "")) (re.++ (re.+ (re.union (re.range "0" "9") (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))) (str.to_re "Z"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)