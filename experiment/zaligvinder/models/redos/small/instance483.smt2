;test regex ^QB([NDR])(.{12})(.{8})(.{8})(.{24})(.{24})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "Q") (re.++ (str.to_re "B") (re.++ (re.union (str.to_re "N") (re.union (str.to_re "D") (str.to_re "R"))) (re.++ ((_ re.loop 12 12) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 8 8) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 8 8) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 24 24) (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 24 24) (re.diff re.allchar (str.to_re "\n"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)