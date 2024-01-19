;test regex "^([^0-9]+?)\\s*([0-9]+)[\\W_]+([0-9]{5})\\s*(.*)$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.+ (re.diff re.allchar (re.range "0" "9"))) (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "s")) (re.++ (re.+ (re.range "0" "9")) (re.++ (re.+ (re.union (str.to_re "\\") (re.union (str.to_re "W") (str.to_re "_")))) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "s")) (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)