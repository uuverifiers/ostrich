;test regex ((Mr |Ms ))?([A-z][a-z]*[ ]?)([A-Z]?(\\.){1}[ ]?)?([A-z]{1}[a-z]*[ ]?)
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "M") (re.++ (str.to_re "r") (str.to_re " "))) (re.++ (str.to_re "M") (re.++ (str.to_re "s") (str.to_re " "))))) (re.++ (re.++ (re.range "A" "z") (re.++ (re.* (re.range "a" "z")) (re.opt (str.to_re " ")))) (re.++ (re.opt (re.++ (re.opt (re.range "A" "Z")) (re.++ ((_ re.loop 1 1) (re.++ (str.to_re "\\") (re.diff re.allchar (str.to_re "\n")))) (re.opt (str.to_re " "))))) (re.++ ((_ re.loop 1 1) (re.range "A" "z")) (re.++ (re.* (re.range "a" "z")) (re.opt (str.to_re " ")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)