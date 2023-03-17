;test regex AB_\d+\.\d+((\.\d){0,1}|\.[BP]\.\d+)\.fuij
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "B") (re.++ (str.to_re "_") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (re.+ (re.range "0" "9")) (re.++ (re.union ((_ re.loop 0 1) (re.++ (str.to_re ".") (re.range "0" "9"))) (re.++ (str.to_re ".") (re.++ (re.union (str.to_re "B") (str.to_re "P")) (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))))) (re.++ (str.to_re ".") (re.++ (str.to_re "f") (re.++ (str.to_re "u") (re.++ (str.to_re "i") (str.to_re "j"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)