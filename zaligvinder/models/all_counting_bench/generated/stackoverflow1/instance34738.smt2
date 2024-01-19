;test regex ^[0-9a-z-]+\.(?:(?:co|or|gv|ac)\.)?[a-z]{2,7}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.union (re.range "0" "9") (re.union (re.range "a" "z") (str.to_re "-")))) (re.++ (str.to_re ".") (re.++ (re.opt (re.++ (re.union (re.union (re.union (re.++ (str.to_re "c") (str.to_re "o")) (re.++ (str.to_re "o") (str.to_re "r"))) (re.++ (str.to_re "g") (str.to_re "v"))) (re.++ (str.to_re "a") (str.to_re "c"))) (str.to_re "."))) ((_ re.loop 2 7) (re.range "a" "z")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)