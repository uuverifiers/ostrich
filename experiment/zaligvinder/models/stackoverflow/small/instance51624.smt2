;test regex \A([^\n]*\n[^\n]*){10,}\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (re.++ (re.* (re.++ (re.* (re.diff re.allchar (str.to_re "\u{0a}"))) (re.++ (str.to_re "\u{0a}") (re.* (re.diff re.allchar (str.to_re "\u{0a}")))))) ((_ re.loop 10 10) (re.++ (re.* (re.diff re.allchar (str.to_re "\u{0a}"))) (re.++ (str.to_re "\u{0a}") (re.* (re.diff re.allchar (str.to_re "\u{0a}"))))))) (str.to_re "z")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)