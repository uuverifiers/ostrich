;test regex [^stuff]{10,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re "s")) (re.inter (re.diff re.allchar (str.to_re "t")) (re.inter (re.diff re.allchar (str.to_re "u")) (re.inter (re.diff re.allchar (str.to_re "f")) (re.diff re.allchar (str.to_re "f"))))))) ((_ re.loop 10 10) (re.inter (re.diff re.allchar (str.to_re "s")) (re.inter (re.diff re.allchar (str.to_re "t")) (re.inter (re.diff re.allchar (str.to_re "u")) (re.inter (re.diff re.allchar (str.to_re "f")) (re.diff re.allchar (str.to_re "f"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)