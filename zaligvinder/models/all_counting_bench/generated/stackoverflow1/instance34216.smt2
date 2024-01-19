;test regex ec2-([0-9]{1,3})-([0-9]{1,3})-([0-9]{1,3})-([0-9]{1,3}).*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "2") (re.++ (str.to_re "-") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)