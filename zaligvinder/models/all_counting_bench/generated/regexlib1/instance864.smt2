;test regex (^\([0]\d{1}\))(\d{7}$)|(^\([0][2]\d{1}\))(\d{6,8}$)|([0][8][0][0])([\s])(\d{5,8}$)
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "(") (re.++ (str.to_re "0") (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ")"))))) (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "(") (re.++ (str.to_re "0") (re.++ (str.to_re "2") (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ")")))))) (re.++ ((_ re.loop 6 8) (re.range "0" "9")) (str.to_re "")))) (re.++ (re.++ (str.to_re "0") (re.++ (str.to_re "8") (re.++ (str.to_re "0") (str.to_re "0")))) (re.++ (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ ((_ re.loop 5 8) (re.range "0" "9")) (str.to_re "")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)