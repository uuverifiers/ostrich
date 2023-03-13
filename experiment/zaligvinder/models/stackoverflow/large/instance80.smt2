;test regex ^[ \t]*([0-9a-z_]{1,100})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}"))) ((_ re.loop 1 100) (re.union (re.range "0" "9") (re.union (re.range "a" "z") (str.to_re "_"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)