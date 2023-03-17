;test regex ^[Tt]20[0-9]{2}[01][0-9][0-3][0-9]\.[0-9]{4}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re "T") (str.to_re "t")) (re.++ (str.to_re "20") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "01") (re.++ (re.range "0" "9") (re.++ (re.range "0" "3") (re.++ (re.range "0" "9") (re.++ (str.to_re ".") ((_ re.loop 4 4) (re.range "0" "9"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)