;test regex IMG\d+_?[a-zA-Z]*\d{0,2}.JPG
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "I") (re.++ (str.to_re "M") (re.++ (str.to_re "G") (re.++ (re.+ (re.range "0" "9")) (re.++ (re.opt (str.to_re "_")) (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "J") (re.++ (str.to_re "P") (str.to_re "G")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)