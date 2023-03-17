;test regex 0|([1-5][0-9]{0,4})|(6[1-4,0][0-9]{0,3})|(65[1-4,0][0-9]{0,2})|(655[1-2,0][0-9])|(6553[1-5,0])
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (str.to_re "0") (re.++ (re.range "1" "5") ((_ re.loop 0 4) (re.range "0" "9")))) (re.++ (str.to_re "6") (re.++ (re.union (re.range "1" "4") (re.union (str.to_re ",") (str.to_re "0"))) ((_ re.loop 0 3) (re.range "0" "9"))))) (re.++ (str.to_re "65") (re.++ (re.union (re.range "1" "4") (re.union (str.to_re ",") (str.to_re "0"))) ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re "655") (re.++ (re.union (re.range "1" "2") (re.union (str.to_re ",") (str.to_re "0"))) (re.range "0" "9")))) (re.++ (str.to_re "6553") (re.union (re.range "1" "5") (re.union (str.to_re ",") (str.to_re "0")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)