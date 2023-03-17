;test regex (.{6}22.{5}\W)(.{6}33.{5})
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 6 6) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "22") (re.++ ((_ re.loop 5 5) (re.diff re.allchar (str.to_re "\n"))) (re.inter (re.diff re.allchar (re.range "a" "z")) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (re.range "0" "9")) (re.diff re.allchar (str.to_re "_")))))))) (re.++ ((_ re.loop 6 6) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "33") ((_ re.loop 5 5) (re.diff re.allchar (str.to_re "\n"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)