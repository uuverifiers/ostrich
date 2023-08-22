;test regex (^1300\d{6}$)|(^1800|1900|1902\d{6}$)|(^0[2|3|7|8]{1}[0-9]{8}$)|(^13\d{4}$)|(^04\d{2,3}\d{6}$)
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "1300") ((_ re.loop 6 6) (re.range "0" "9")))) (str.to_re "")) (re.union (re.union (re.++ (str.to_re "") (str.to_re "1800")) (str.to_re "1900")) (re.++ (re.++ (str.to_re "1902") ((_ re.loop 6 6) (re.range "0" "9"))) (str.to_re "")))) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "0") (re.++ ((_ re.loop 1 1) (re.union (str.to_re "2") (re.union (str.to_re "|") (re.union (str.to_re "3") (re.union (str.to_re "|") (re.union (str.to_re "7") (re.union (str.to_re "|") (str.to_re "8")))))))) ((_ re.loop 8 8) (re.range "0" "9"))))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "13") ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "04") (re.++ ((_ re.loop 2 3) (re.range "0" "9")) ((_ re.loop 6 6) (re.range "0" "9"))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)