;test regex (^(([0-9]{10}\t).*\r\n)((([0-9]{1})|([0-9]{2}))\t.*\r\n))
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.++ (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "\u{09}")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}")))) (re.++ (re.union ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "\u{09}") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)