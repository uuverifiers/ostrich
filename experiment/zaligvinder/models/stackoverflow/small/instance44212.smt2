;test regex ^(01\d{14})(17\d{6})?(10\w{1,20})?(21\w{1,20})?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "01") ((_ re.loop 14 14) (re.range "0" "9"))) (re.++ (re.opt (re.++ (str.to_re "17") ((_ re.loop 6 6) (re.range "0" "9")))) (re.++ (re.opt (re.++ (str.to_re "10") ((_ re.loop 1 20) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))) (re.opt (re.++ (str.to_re "21") ((_ re.loop 1 20) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)