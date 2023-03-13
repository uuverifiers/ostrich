;test regex [^\u{00}-\u{21}\u{ff}]{1,250}$
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 250) (re.inter (re.diff re.allchar (re.range "\u{00}" "\u{21}")) (re.diff re.allchar (str.to_re "\u{ff}")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)