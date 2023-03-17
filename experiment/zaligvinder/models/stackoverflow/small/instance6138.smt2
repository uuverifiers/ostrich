;test regex (?:([a-z]{2,})_)?(\d+)_([a-z]{2,}\d+)_(\d+)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.opt (re.++ (re.++ (re.* (re.range "a" "z")) ((_ re.loop 2 2) (re.range "a" "z"))) (str.to_re "_"))) (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (re.++ (re.++ (re.* (re.range "a" "z")) ((_ re.loop 2 2) (re.range "a" "z"))) (re.+ (re.range "0" "9"))) (re.++ (str.to_re "_") (re.+ (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)