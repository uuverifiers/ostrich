;test regex .{128}webimg.{10}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 128 128) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "w") (re.++ (str.to_re "e") (re.++ (str.to_re "b") (re.++ (str.to_re "i") (re.++ (str.to_re "m") (re.++ (str.to_re "g") ((_ re.loop 10 10) (re.diff re.allchar (str.to_re "\n"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)