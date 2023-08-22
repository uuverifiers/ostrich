;test regex ^[a-zA-Z0-9\-]*[-]{1}[vV]{1}[mM]{1}\.companynanme\.local$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "-"))))) (re.++ ((_ re.loop 1 1) (str.to_re "-")) (re.++ ((_ re.loop 1 1) (re.union (str.to_re "v") (str.to_re "V"))) (re.++ ((_ re.loop 1 1) (re.union (str.to_re "m") (str.to_re "M"))) (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "y") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re ".") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "c") (re.++ (str.to_re "a") (str.to_re "l")))))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)