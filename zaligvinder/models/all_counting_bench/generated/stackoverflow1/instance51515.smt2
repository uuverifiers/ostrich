;test regex [0-9]{1,3}\\.[0-9]{1,3}\\.(16|249)\\.10
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.union (str.to_re "16") (str.to_re "249")) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (str.to_re "10"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)