;test regex ^([0-9]{3})(L[0-9]{4}[0-9A-F]{6})?(N[0-9A-F]{6})?(K[0-9]+)?(M([0-9A-F]{6})+|MX{6})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.opt (re.++ (str.to_re "L") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 6 6) (re.union (re.range "0" "9") (re.range "A" "F")))))) (re.++ (re.opt (re.++ (str.to_re "N") ((_ re.loop 6 6) (re.union (re.range "0" "9") (re.range "A" "F"))))) (re.++ (re.opt (re.++ (str.to_re "K") (re.+ (re.range "0" "9")))) (re.union (re.++ (str.to_re "M") (re.+ ((_ re.loop 6 6) (re.union (re.range "0" "9") (re.range "A" "F"))))) (re.++ (str.to_re "M") ((_ re.loop 6 6) (str.to_re "X"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)