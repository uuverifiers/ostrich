;test regex split("(\r\n){2,}",$nb);
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (re.++ (re.* (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) ((_ re.loop 2 2) (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}")))) (str.to_re "\u{22}"))) (str.to_re ",")) (re.++ (str.to_re "") (re.++ (str.to_re "n") (str.to_re "b")))) (str.to_re ";")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)