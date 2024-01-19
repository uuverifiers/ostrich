;test regex ^ZATR0*(\d{2,3})_\d+\.pdf$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "Z") (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ (str.to_re "R") (re.++ (re.* (str.to_re "0")) (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (str.to_re "p") (re.++ (str.to_re "d") (str.to_re "f"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)