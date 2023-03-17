;test regex -([0-9]+)_([1-2]{1}).html
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "-") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 1 1) (re.range "1" "2")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "m") (str.to_re "l")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)