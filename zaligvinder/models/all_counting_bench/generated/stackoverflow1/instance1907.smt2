;test regex ~s/\d{4}_\d{2}_\d{1,2}_\K0(\d)_0(\d)/$1_$2/
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "~") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (str.to_re "K") (re.++ (str.to_re "0") (re.++ (re.range "0" "9") (re.++ (str.to_re "_") (re.++ (str.to_re "0") (re.++ (re.range "0" "9") (str.to_re "/")))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (str.to_re "_")))) (re.++ (str.to_re "") (re.++ (str.to_re "2") (str.to_re "/"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)