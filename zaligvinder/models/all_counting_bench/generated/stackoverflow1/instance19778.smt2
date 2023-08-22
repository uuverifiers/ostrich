;test regex ([a-bA-B0-9_])-([0-9]{4})-([0-9]{2})-([04]{2})-No(.+)\.(.+)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.union (re.range "a" "b") (re.union (re.range "A" "B") (re.union (re.range "0" "9") (str.to_re "_")))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (str.to_re "04")) (re.++ (str.to_re "-") (re.++ (str.to_re "N") (re.++ (str.to_re "o") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ".") (re.+ (re.diff re.allchar (str.to_re "\n"))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)