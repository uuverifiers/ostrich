;test regex "[0-9]-[0-9]:1.7.0\([0]{1,}(.*)\\*kW\)"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.range "0" "9") (re.++ (str.to_re "-") (re.++ (re.range "0" "9") (re.++ (str.to_re ":") (re.++ (str.to_re "1") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "7") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "0") (re.++ (str.to_re "(") (re.++ (re.++ (re.* (str.to_re "0")) ((_ re.loop 1 1) (str.to_re "0"))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.* (str.to_re "\\")) (re.++ (str.to_re "k") (re.++ (str.to_re "W") (re.++ (str.to_re ")") (str.to_re "\u{22}"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)