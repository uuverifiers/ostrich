;test regex ^[0-9]{1}$|^[1-6]{1}[0-3]{1}$|^64$|\-[1-9]{1}$|^\-[1-6]{1}[0-3]{1}$|^\-64$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.++ (re.++ (str.to_re "") ((_ re.loop 1 1) (re.range "0" "9"))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (re.range "1" "6")) ((_ re.loop 1 1) (re.range "0" "3")))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (str.to_re "64")) (str.to_re ""))) (re.++ (re.++ (str.to_re "-") ((_ re.loop 1 1) (re.range "1" "9"))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "-") (re.++ ((_ re.loop 1 1) (re.range "1" "6")) ((_ re.loop 1 1) (re.range "0" "3"))))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "-") (str.to_re "64"))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)