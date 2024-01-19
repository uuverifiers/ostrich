;test regex ^ *(1[56])? *(\d{5}) *(0?[56]) *([A-Z]) *(\d{1,2}) *$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (str.to_re " ")) (re.++ (re.opt (re.++ (str.to_re "1") (str.to_re "56"))) (re.++ (re.* (str.to_re " ")) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.* (str.to_re " ")) (re.++ (re.++ (re.opt (str.to_re "0")) (str.to_re "56")) (re.++ (re.* (str.to_re " ")) (re.++ (re.range "A" "Z") (re.++ (re.* (str.to_re " ")) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.* (str.to_re " "))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)