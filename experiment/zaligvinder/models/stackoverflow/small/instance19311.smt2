;test regex (?:\r?\n){2}([^\r\n]+)|(?:^|\r?\n)([^\r\n]+)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.++ (re.opt (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))) (re.+ (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}"))))) (re.++ (re.union (str.to_re "") (re.++ (re.opt (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))) (re.+ (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)