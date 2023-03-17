;test regex ^([a-zA-Z]:|\\{2}\w+\$?)(\\\w{2}.*)+\.(jpe?g|JPE?G)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":")) (re.++ ((_ re.loop 2 2) (str.to_re "\\")) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.opt (str.to_re "$"))))) (re.++ (re.+ (re.++ (str.to_re "\\") (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.* (re.diff re.allchar (str.to_re "\n")))))) (re.++ (str.to_re ".") (re.union (re.++ (str.to_re "j") (re.++ (str.to_re "p") (re.++ (re.opt (str.to_re "e")) (str.to_re "g")))) (re.++ (str.to_re "J") (re.++ (str.to_re "P") (re.++ (re.opt (str.to_re "E")) (str.to_re "G"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)