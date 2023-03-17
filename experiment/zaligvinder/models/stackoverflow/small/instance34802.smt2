;test regex ([a-h,A-H,j-n,J-N,p-z,P-Z,0-9]){17}$
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 17 17) (re.union (re.range "a" "h") (re.union (str.to_re ",") (re.union (re.range "A" "H") (re.union (str.to_re ",") (re.union (re.range "j" "n") (re.union (str.to_re ",") (re.union (re.range "J" "N") (re.union (str.to_re ",") (re.union (re.range "p" "z") (re.union (str.to_re ",") (re.union (re.range "P" "Z") (re.union (str.to_re ",") (re.range "0" "9")))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)