;test regex ^(([0-9]{1})|([0-9]{1}[0-9]{1})|([1-3]{1}[0-6]{1}[0-5]{1}))d(([0-9]{1})|(1[0-9]{1})|([1-2]{1}[0-3]{1}))h(([0-9]{1})|([1-5]{1}[0-9]{1}))m$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")))) (re.++ ((_ re.loop 1 1) (re.range "1" "3")) (re.++ ((_ re.loop 1 1) (re.range "0" "6")) ((_ re.loop 1 1) (re.range "0" "5"))))) (re.++ (str.to_re "d") (re.++ (re.union (re.union ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (str.to_re "1") ((_ re.loop 1 1) (re.range "0" "9")))) (re.++ ((_ re.loop 1 1) (re.range "1" "2")) ((_ re.loop 1 1) (re.range "0" "3")))) (re.++ (str.to_re "h") (re.++ (re.union ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "5")) ((_ re.loop 1 1) (re.range "0" "9")))) (str.to_re "m"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)