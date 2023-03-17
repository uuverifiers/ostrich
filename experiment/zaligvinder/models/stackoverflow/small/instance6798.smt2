;test regex ^WI-(?:20[0-9]{2}|2100)(?:-\d+)+$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "W") (re.++ (str.to_re "I") (re.++ (str.to_re "-") (re.++ (re.union (re.++ (str.to_re "20") ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "2100")) (re.+ (re.++ (str.to_re "-") (re.+ (re.range "0" "9"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)