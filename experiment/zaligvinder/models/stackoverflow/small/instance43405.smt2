;test regex /v/[a-f0-9]{32}(/[a-z-]+(/\d+)?)?
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ (str.to_re "v") (re.++ (str.to_re "/") (re.++ ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.opt (re.++ (str.to_re "/") (re.++ (re.+ (re.union (re.range "a" "z") (str.to_re "-"))) (re.opt (re.++ (str.to_re "/") (re.+ (re.range "0" "9")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)