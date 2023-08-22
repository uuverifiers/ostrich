;test regex ^image(?:test|-net|-deploy)-([0-9a-f]+-)?([a-z0-9]{5})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "i") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (re.union (re.union (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (str.to_re "t")))) (re.++ (str.to_re "-") (re.++ (str.to_re "n") (re.++ (str.to_re "e") (str.to_re "t"))))) (re.++ (str.to_re "-") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (str.to_re "y")))))))) (re.++ (str.to_re "-") (re.++ (re.opt (re.++ (re.+ (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "-"))) ((_ re.loop 5 5) (re.union (re.range "a" "z") (re.range "0" "9")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)