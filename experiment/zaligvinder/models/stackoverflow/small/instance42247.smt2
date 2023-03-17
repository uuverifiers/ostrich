;test regex "[^|\\s|>]*([a-z]{2}[0-9]+\\.?)\\b"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re "|")) (re.inter (re.diff re.allchar (str.to_re "\\")) (re.inter (re.diff re.allchar (str.to_re "s")) (re.inter (re.diff re.allchar (str.to_re "|")) (re.diff re.allchar (str.to_re ">"))))))) (re.++ (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "\\") (re.opt (re.diff re.allchar (str.to_re "\n")))))) (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (str.to_re "\u{22}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)