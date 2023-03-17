;test regex ^.*=(?:2017-(?:11-(?:0[6-9]|[12][0-9]|30)|12-\d{2})|2018-\d{2}-\d{2})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "=") (re.union (re.++ (str.to_re "2017") (re.++ (str.to_re "-") (re.union (re.++ (str.to_re "11") (re.++ (str.to_re "-") (re.union (re.union (re.++ (str.to_re "0") (re.range "6" "9")) (re.++ (str.to_re "12") (re.range "0" "9"))) (str.to_re "30")))) (re.++ (str.to_re "12") (re.++ (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))))))) (re.++ (str.to_re "2018") (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)