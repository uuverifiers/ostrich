;test regex ([01]?[0-9]{1}|2[0-3]{1})\u0020*[:.]\u0020*[0-5]{1}[0-9]{1}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "01")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "2") ((_ re.loop 1 1) (re.range "0" "3")))) (re.++ (re.* (str.to_re "\u{0020}")) (re.++ (re.union (str.to_re ":") (str.to_re ".")) (re.++ (re.* (str.to_re "\u{0020}")) (re.++ ((_ re.loop 1 1) (re.range "0" "5")) ((_ re.loop 1 1) (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)