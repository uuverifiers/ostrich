;test regex ^\n*[hH][tT]{2}[pP]\u{3a}\u{2f}\u{2f}[^\n]{400}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (str.to_re "\u{0a}")) (re.++ (re.union (str.to_re "h") (str.to_re "H")) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "t") (str.to_re "T"))) (re.++ (re.union (str.to_re "p") (str.to_re "P")) (re.++ (str.to_re "\u{3a}") (re.++ (str.to_re "\u{2f}") (re.++ (str.to_re "\u{2f}") ((_ re.loop 400 400) (re.diff re.allchar (str.to_re "\u{0a}")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)