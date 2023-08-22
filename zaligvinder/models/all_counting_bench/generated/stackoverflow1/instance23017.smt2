;test regex 234(?:706|803|806|810|813|816)\d{7}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "234") (re.++ (re.union (re.union (re.union (re.union (re.union (str.to_re "706") (str.to_re "803")) (str.to_re "806")) (str.to_re "810")) (str.to_re "813")) (str.to_re "816")) ((_ re.loop 7 7) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)