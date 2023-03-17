;test regex .{8}-.{4}-.{4}-.{12}-id
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 12 12) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "-") (re.++ (str.to_re "i") (str.to_re "d"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)