;test regex (\d{1,2}(h))*(\d{1,2}(m))*(\d{1,2}(\.\d+)*(s))*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "h"))) (re.++ (re.* (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "m"))) (re.* (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.* (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (str.to_re "s"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)