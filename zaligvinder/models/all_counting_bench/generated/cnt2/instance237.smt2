;test regex \u{20}[^\u{21}\u{22}]{500}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{20}") ((_ re.loop 500 500) (re.inter (re.diff re.allchar (str.to_re "\u{21}")) (re.diff re.allchar (str.to_re "\u{22}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)