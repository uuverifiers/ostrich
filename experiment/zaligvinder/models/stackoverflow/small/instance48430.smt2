;test regex (.+[0-9]{18,})(_[0-9]+)?\\.txt$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.* (re.range "0" "9")) ((_ re.loop 18 18) (re.range "0" "9")))) (re.++ (re.opt (re.++ (str.to_re "_") (re.+ (re.range "0" "9")))) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "t") (re.++ (str.to_re "x") (str.to_re "t"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)