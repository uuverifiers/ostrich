;test regex (\n{2}|^)((?:[^\n]|[^\n]\n[^\n]){500,})(\n{2}|$)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union ((_ re.loop 2 2) (str.to_re "\u{0a}")) (str.to_re "")) (re.++ (re.++ (re.* (re.union (re.diff re.allchar (str.to_re "\u{0a}")) (re.++ (re.diff re.allchar (str.to_re "\u{0a}")) (re.++ (str.to_re "\u{0a}") (re.diff re.allchar (str.to_re "\u{0a}")))))) ((_ re.loop 500 500) (re.union (re.diff re.allchar (str.to_re "\u{0a}")) (re.++ (re.diff re.allchar (str.to_re "\u{0a}")) (re.++ (str.to_re "\u{0a}") (re.diff re.allchar (str.to_re "\u{0a}"))))))) (re.union ((_ re.loop 2 2) (str.to_re "\u{0a}")) (str.to_re ""))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)