;test regex ^(.{10})(.{100})(.{2})(.{50})(.{50})(.{50})(.{4})(.{2})(.{60})(.{20})(.{20})(.{80})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 10 10) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 100 100) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 50 50) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 50 50) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 50 50) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 60 60) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 20 20) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 20 20) (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 80 80) (re.diff re.allchar (str.to_re "\n")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)