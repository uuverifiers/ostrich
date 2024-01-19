;test regex ISBN (978|979)[ |-][0-9]{1,5}[ |-][0-9]{1,7}[ |-][0-9]{1,7}[0-9]{1}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "I") (re.++ (str.to_re "S") (re.++ (str.to_re "B") (re.++ (str.to_re "N") (re.++ (str.to_re " ") (re.++ (re.union (str.to_re "978") (str.to_re "979")) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "|") (str.to_re "-"))) (re.++ ((_ re.loop 1 5) (re.range "0" "9")) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "|") (str.to_re "-"))) (re.++ ((_ re.loop 1 7) (re.range "0" "9")) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "|") (str.to_re "-"))) (re.++ ((_ re.loop 1 7) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)