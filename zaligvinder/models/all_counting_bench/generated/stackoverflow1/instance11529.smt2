;test regex (?:"(?:[^"\\\n]|\\.)*){2}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 2 2) (re.++ (str.to_re "\u{22}") (re.* (re.union (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.inter (re.diff re.allchar (str.to_re "\\")) (re.diff re.allchar (str.to_re "\u{0a}")))) (re.++ (str.to_re "\\") (re.diff re.allchar (str.to_re "\n")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)