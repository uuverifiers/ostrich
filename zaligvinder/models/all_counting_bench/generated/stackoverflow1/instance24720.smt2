;test regex ^0*(\d{0,7}(\.\d+)?|1\d{7}(\.\d+)?|2[0-4]\d{6}(\.(9([0-8]\d*)?|990*|[0-8]\d*))?)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (str.to_re "0")) (re.union (re.union (re.++ ((_ re.loop 0 7) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))) (re.++ (str.to_re "1") (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))))) (re.++ (str.to_re "2") (re.++ (re.range "0" "4") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.union (re.union (re.++ (str.to_re "9") (re.opt (re.++ (re.range "0" "8") (re.* (re.range "0" "9"))))) (re.* (str.to_re "990"))) (re.++ (re.range "0" "8") (re.* (re.range "0" "9")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)