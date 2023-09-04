;test regex ([0-9-]{8})_([^-]+)-([a-z_]+).([a-z]+)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.union (re.range "0" "9") (str.to_re "-"))) (re.++ (str.to_re "_") (re.++ (re.+ (re.diff re.allchar (str.to_re "-"))) (re.++ (str.to_re "-") (re.++ (re.+ (re.union (re.range "a" "z") (str.to_re "_"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.+ (re.range "a" "z"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)