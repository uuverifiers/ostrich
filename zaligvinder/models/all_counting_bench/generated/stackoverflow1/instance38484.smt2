;test regex ^(?:(?:\r?\n)*[^\r\n]){1,7}(?:\r?\n)*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 7) (re.++ (re.* (re.++ (re.opt (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}"))))) (re.* (re.++ (re.opt (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)