;test regex \(\s*(\u{27}[^\u{27}]{1024,}|\u{22}[^\u{22}]{1024,})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "(") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.union (re.++ (str.to_re "\u{27}") (re.++ (re.* (re.diff re.allchar (str.to_re "\u{27}"))) ((_ re.loop 1024 1024) (re.diff re.allchar (str.to_re "\u{27}"))))) (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.diff re.allchar (str.to_re "\u{22}"))) ((_ re.loop 1024 1024) (re.diff re.allchar (str.to_re "\u{22}"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)