;test regex (.*)auth=TTX\w{15}(.*)
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "a") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "=") (re.++ (str.to_re "T") (re.++ (str.to_re "T") (re.++ (str.to_re "X") (re.++ ((_ re.loop 15 15) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.* (re.diff re.allchar (str.to_re "\n")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)