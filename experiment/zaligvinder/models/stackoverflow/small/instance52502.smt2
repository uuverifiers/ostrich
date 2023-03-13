;test regex "^[0-9A-F+]{8}[\\s]{2}[0-9A-F\\s]{34}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.union (re.range "A" "F") (str.to_re "+")))) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "\\") (str.to_re "s"))) (re.++ ((_ re.loop 34 34) (re.union (re.range "0" "9") (re.union (re.range "A" "F") (re.union (str.to_re "\\") (str.to_re "s"))))) (str.to_re "\u{22}"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)