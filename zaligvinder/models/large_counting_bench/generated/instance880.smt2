;test regex .{30}Value_*|.{55}Value2_*
(declare-const X String)
(assert (str.in_re X (re.union (re.++ ((_ re.loop 30 30) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "V") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (re.++ (str.to_re "e") (re.* (str.to_re "_")))))))) (re.++ ((_ re.loop 55 55) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "V") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (re.++ (str.to_re "e") (re.++ (str.to_re "2") (re.* (str.to_re "_"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)