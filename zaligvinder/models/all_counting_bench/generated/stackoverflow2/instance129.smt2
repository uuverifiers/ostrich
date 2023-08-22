;test regex .{56}(.*(EVENT|OFF))
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 56 56) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.union (re.++ (str.to_re "E") (re.++ (str.to_re "V") (re.++ (str.to_re "E") (re.++ (str.to_re "N") (str.to_re "T"))))) (re.++ (str.to_re "O") (re.++ (str.to_re "F") (str.to_re "F"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)