;test regex 0x(?:[0-9a-f]{40}|[0-9A-F]{40})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "0") (re.++ (str.to_re "x") (re.union ((_ re.loop 40 40) (re.union (re.range "0" "9") (re.range "a" "f"))) ((_ re.loop 40 40) (re.union (re.range "0" "9") (re.range "A" "F"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)