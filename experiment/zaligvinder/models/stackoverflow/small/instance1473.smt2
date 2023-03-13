;test regex '"'("\\x"[a-fA-F0-9]{2}|"\\u"[a-fA-F0-9]{4}|"\\"[^xu]|[^"\n\\])*'"'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\u{27}") (re.++ (re.* (re.union (re.union (re.union (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (str.to_re "x") (re.++ (str.to_re "\u{22}") ((_ re.loop 2 2) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9")))))))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (str.to_re "u") (re.++ (str.to_re "\u{22}") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9"))))))))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (str.to_re "\u{22}") (re.inter (re.diff re.allchar (str.to_re "x")) (re.diff re.allchar (str.to_re "u"))))))) (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.inter (re.diff re.allchar (str.to_re "\u{0a}")) (re.diff re.allchar (str.to_re "\\")))))) (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "\u{22}") (str.to_re "\u{27}")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)