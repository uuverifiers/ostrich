;test regex /\[size=(?:200|1\d{2}|[1-9]\d?)\](.+?)\[\/size\]/
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ (str.to_re "[") (re.++ (str.to_re "s") (re.++ (str.to_re "i") (re.++ (str.to_re "z") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ (re.union (re.union (str.to_re "200") (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (re.range "1" "9") (re.opt (re.range "0" "9")))) (re.++ (str.to_re "]") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "[") (re.++ (str.to_re "/") (re.++ (str.to_re "s") (re.++ (str.to_re "i") (re.++ (str.to_re "z") (re.++ (str.to_re "e") (re.++ (str.to_re "]") (str.to_re "/"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)