;test regex ([+][353]{3})[\d\s]{7,11}|([+][44]{2})[\d\s]{7,11}
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "+") ((_ re.loop 3 3) (str.to_re "353"))) ((_ re.loop 7 11) (re.union (re.range "0" "9") (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))) (re.++ (re.++ (str.to_re "+") ((_ re.loop 2 2) (str.to_re "44"))) ((_ re.loop 7 11) (re.union (re.range "0" "9") (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)