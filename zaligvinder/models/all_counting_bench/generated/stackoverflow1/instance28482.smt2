;test regex ^([a-z0-9][-a-z0-9_\+\.]*[a-z0-9])@([a-z0-9][-a-z0-9\.]*[a-z0-9]\.(com|asia)|([0-9]{1,3}\.{3}[0-9]{1,3}))*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.++ (re.* (re.union (str.to_re "-") (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re "_") (re.union (str.to_re "+") (str.to_re "."))))))) (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (str.to_re "@") (re.* (re.union (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.++ (re.* (re.union (str.to_re "-") (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "."))))) (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.++ (str.to_re ".") (re.union (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m"))) (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "i") (str.to_re "a"))))))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ ((_ re.loop 3 3) (str.to_re ".")) ((_ re.loop 1 3) (re.range "0" "9"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)