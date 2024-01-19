;test regex (?:\/{2}.*?$|\/\*.*?\*\/)*.?((?:\d{4}-){3}\d{4}|\d{8}|\d{6}\/\d{2})
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.union (re.++ (re.++ ((_ re.loop 2 2) (str.to_re "/")) (re.* (re.diff re.allchar (str.to_re "\n")))) (str.to_re "")) (re.++ (str.to_re "/") (re.++ (str.to_re "*") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "*") (str.to_re "/"))))))) (re.++ (re.opt (re.diff re.allchar (str.to_re "\n"))) (re.union (re.union (re.++ ((_ re.loop 3 3) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-"))) ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (str.to_re "/") ((_ re.loop 2 2) (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)