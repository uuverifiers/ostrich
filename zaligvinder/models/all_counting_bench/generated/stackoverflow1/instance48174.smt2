;test regex ([023]){0,1}1st|([02]){0,1}2nd|([02]){0,1}3rd|(11|12|13|30|(([012]){0,1}(([4-9])|0))th)
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ ((_ re.loop 0 1) (str.to_re "023")) (re.++ (str.to_re "1") (re.++ (str.to_re "s") (str.to_re "t")))) (re.++ ((_ re.loop 0 1) (str.to_re "02")) (re.++ (str.to_re "2") (re.++ (str.to_re "n") (str.to_re "d"))))) (re.++ ((_ re.loop 0 1) (str.to_re "02")) (re.++ (str.to_re "3") (re.++ (str.to_re "r") (str.to_re "d"))))) (re.union (re.union (re.union (re.union (str.to_re "11") (str.to_re "12")) (str.to_re "13")) (str.to_re "30")) (re.++ (re.++ ((_ re.loop 0 1) (str.to_re "012")) (re.union (re.range "4" "9") (str.to_re "0"))) (re.++ (str.to_re "t") (str.to_re "h")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)