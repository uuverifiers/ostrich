;test regex (^([1-3]{1}[0-9]{0,}(\.[0-9]{1})?|0(\.[0-9]{1})?|[4]{1}[0-9]{0,}(\.[0]{1})?|5(\.[5]{1}))$)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "3")) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 0 0) (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9")))))) (re.++ (str.to_re "0") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9")))))) (re.++ ((_ re.loop 1 1) (str.to_re "4")) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 0 0) (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 1) (str.to_re "0"))))))) (re.++ (str.to_re "5") (re.++ (str.to_re ".") ((_ re.loop 1 1) (str.to_re "5")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)