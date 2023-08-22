;test regex "^[AKQJT2-9][hscd]{2}$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.union (str.to_re "A") (re.union (str.to_re "K") (re.union (str.to_re "Q") (re.union (str.to_re "J") (re.union (str.to_re "T") (re.range "2" "9")))))) ((_ re.loop 2 2) (re.union (str.to_re "h") (re.union (str.to_re "s") (re.union (str.to_re "c") (str.to_re "d")))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)