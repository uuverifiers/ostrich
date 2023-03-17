;test regex ^-?([1-8]?[0-9]\.{1}\d{1,6}$|90\.{1}0{1,6}$)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.++ (re.opt (re.range "1" "8")) (re.++ (re.range "0" "9") (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (re.range "0" "9"))))) (str.to_re "")) (re.++ (re.++ (str.to_re "90") (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (str.to_re "0")))) (str.to_re "")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)