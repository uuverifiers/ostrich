;test regex ^(?:000|666|9\d\d)|^\d{3}-?00|0{4}$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "") (re.union (re.union (str.to_re "000") (str.to_re "666")) (re.++ (str.to_re "9") (re.++ (re.range "0" "9") (re.range "0" "9"))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.opt (str.to_re "-")) (str.to_re "00"))))) (re.++ ((_ re.loop 4 4) (str.to_re "0")) (str.to_re "")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)