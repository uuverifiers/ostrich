;test regex ^[a-z0-9'\(\)\+_\-,\.\/:=\?\ ]{0,69}[a-z0-9'\(\)\+_\-,\.\/:=\?]$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 0 69) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re "\u{27}") (re.union (str.to_re "(") (re.union (str.to_re ")") (re.union (str.to_re "+") (re.union (str.to_re "_") (re.union (str.to_re "-") (re.union (str.to_re ",") (re.union (str.to_re ".") (re.union (str.to_re "/") (re.union (str.to_re ":") (re.union (str.to_re "=") (re.union (str.to_re "?") (str.to_re " ")))))))))))))))) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re "\u{27}") (re.union (str.to_re "(") (re.union (str.to_re ")") (re.union (str.to_re "+") (re.union (str.to_re "_") (re.union (str.to_re "-") (re.union (str.to_re ",") (re.union (str.to_re ".") (re.union (str.to_re "/") (re.union (str.to_re ":") (re.union (str.to_re "=") (str.to_re "?")))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)