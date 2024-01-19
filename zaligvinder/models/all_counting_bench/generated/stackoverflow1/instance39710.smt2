;test regex ^[Hh]{1}\d{1}[A-Za-z]-{1} *\d{1}[A-Za-z]{1}\d{1}|^[Hh]{1}\d{1}[A-Za-z]{1} *\d{1}[A-Za-z]{1}\d{1}
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (re.union (str.to_re "H") (str.to_re "h"))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.++ ((_ re.loop 1 1) (str.to_re "-")) (re.++ (re.* (str.to_re " ")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 1) (re.range "0" "9")))))))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (re.union (str.to_re "H") (str.to_re "h"))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (re.* (str.to_re " ")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 1) (re.range "0" "9"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)