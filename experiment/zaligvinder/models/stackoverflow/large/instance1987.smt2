;test regex (0(\.\d{1,2})?|[1-9](\d{0,63}|\d{0,61}\.\d|\d{0,60}\.\d\d))
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "0") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))) (re.++ (re.range "1" "9") (re.union (re.union ((_ re.loop 0 63) (re.range "0" "9")) (re.++ ((_ re.loop 0 61) (re.range "0" "9")) (re.++ (str.to_re ".") (re.range "0" "9")))) (re.++ ((_ re.loop 0 60) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (re.range "0" "9") (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)