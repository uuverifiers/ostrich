;test regex ^CON\w{1,10}\d+\u{20}[^\r\n]{1,20}\u{20}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "C") (re.++ (str.to_re "O") (re.++ (str.to_re "N") (re.++ ((_ re.loop 1 10) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "\u{20}") (re.++ ((_ re.loop 1 20) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}")))) (str.to_re "\u{20}")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)