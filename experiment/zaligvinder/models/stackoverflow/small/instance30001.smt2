;test regex ^(?:[0-9]{1,16}|[\n\r -Z_\u00A0\u03A9]{1,11})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union ((_ re.loop 1 16) (re.range "0" "9")) ((_ re.loop 1 11) (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (re.range " " "Z") (re.union (str.to_re "_") (re.union (str.to_re "\u{00a0}") (str.to_re "\u{03a9}"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)