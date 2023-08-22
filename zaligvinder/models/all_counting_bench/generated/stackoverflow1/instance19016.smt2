;test regex gsub('[a-zA-Z]+([0-9]{5})\\.([a-zA-Z])+','\\1','htf84756.iuy')
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "g") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (str.to_re "\u{27}") (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{27}"))))))) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "\\") (re.++ (str.to_re "1") (str.to_re "\u{27}")))))) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "f") (re.++ (str.to_re "84756") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "i") (re.++ (str.to_re "u") (re.++ (str.to_re "y") (str.to_re "\u{27}"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)