;test regex \m(.{1})ori
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "m") (re.++ ((_ re.loop 1 1) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "o") (re.++ (str.to_re "r") (str.to_re "i")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)