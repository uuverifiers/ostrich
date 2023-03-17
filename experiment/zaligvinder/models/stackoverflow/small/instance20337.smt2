;test regex 2008[\n\r](?:.*[\n\r]){4}(.*[\n\r].*)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "2008") (re.++ (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}")) (re.++ ((_ re.loop 4 4) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}")))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}")) (re.* (re.diff re.allchar (str.to_re "\n"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)