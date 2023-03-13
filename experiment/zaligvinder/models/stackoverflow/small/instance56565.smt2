;test regex 142006680\d|14200668[1-9]\d|14200669\d{2}|142006[7-9]\d{3}|14200[7-9]\d{4}|14201[0-4]\d{4}|142015[0-2]\d{3}|1420153[0-1]\d{2}
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "142006680") (re.range "0" "9")) (re.++ (str.to_re "14200668") (re.++ (re.range "1" "9") (re.range "0" "9")))) (re.++ (str.to_re "14200669") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "142006") (re.++ (re.range "7" "9") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (str.to_re "14200") (re.++ (re.range "7" "9") ((_ re.loop 4 4) (re.range "0" "9"))))) (re.++ (str.to_re "14201") (re.++ (re.range "0" "4") ((_ re.loop 4 4) (re.range "0" "9"))))) (re.++ (str.to_re "142015") (re.++ (re.range "0" "2") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (str.to_re "1420153") (re.++ (re.range "0" "1") ((_ re.loop 2 2) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)