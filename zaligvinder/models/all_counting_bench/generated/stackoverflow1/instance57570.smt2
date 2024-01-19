;test regex @"^20\d{2}[0-1]\d[1-3]\d*$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "@") (str.to_re "\u{22}")) (re.++ (str.to_re "") (re.++ (str.to_re "20") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.range "0" "1") (re.++ (re.range "0" "9") (re.++ (re.range "1" "3") (re.* (re.range "0" "9"))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)