;test regex ((Mr |Ms ))?([A-Z][A-Za-z']*[ ]?)([A-Z]?(\.){1}[ ]?)?([A-z]{1}[A-Za-z']*[ ]?)
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "M") (re.++ (str.to_re "r") (str.to_re " "))) (re.++ (str.to_re "M") (re.++ (str.to_re "s") (str.to_re " "))))) (re.++ (re.++ (re.range "A" "Z") (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (str.to_re "\u{27}")))) (re.opt (str.to_re " ")))) (re.++ (re.opt (re.++ (re.opt (re.range "A" "Z")) (re.++ ((_ re.loop 1 1) (str.to_re ".")) (re.opt (str.to_re " "))))) (re.++ ((_ re.loop 1 1) (re.range "A" "z")) (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (str.to_re "\u{27}")))) (re.opt (str.to_re " ")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)