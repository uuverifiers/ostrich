;test regex (.*?)(\d{2,4})[^\d]{1,5}(\d{3,4})[^\d]{1,5}(\d{4,6})(.*?)
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 2 4) (re.range "0" "9")) (re.++ ((_ re.loop 1 5) (re.diff re.allchar (re.range "0" "9"))) (re.++ ((_ re.loop 3 4) (re.range "0" "9")) (re.++ ((_ re.loop 1 5) (re.diff re.allchar (re.range "0" "9"))) (re.++ ((_ re.loop 4 6) (re.range "0" "9")) (re.* (re.diff re.allchar (str.to_re "\n")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)