;test regex /[01][0-9]/[0-3][0-9]/[0-9]{4} [0-2]?[0-9]:[0-6]?[0-9]:[0-6]?[0-9] (AM|PM)/
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ (str.to_re "01") (re.++ (re.range "0" "9") (re.++ (str.to_re "/") (re.++ (re.range "0" "3") (re.++ (re.range "0" "9") (re.++ (str.to_re "/") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (re.opt (re.range "0" "2")) (re.++ (re.range "0" "9") (re.++ (str.to_re ":") (re.++ (re.opt (re.range "0" "6")) (re.++ (re.range "0" "9") (re.++ (str.to_re ":") (re.++ (re.opt (re.range "0" "6")) (re.++ (re.range "0" "9") (re.++ (str.to_re " ") (re.++ (re.union (re.++ (str.to_re "A") (str.to_re "M")) (re.++ (str.to_re "P") (str.to_re "M"))) (str.to_re "/"))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)