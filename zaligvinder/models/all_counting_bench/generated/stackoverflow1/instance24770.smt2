;test regex ^(?:AC.{2}|.CF.|.{2}FG|A.F.|A.{2}G|.C.G)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "A") (re.++ (str.to_re "C") ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "C") (re.++ (str.to_re "F") (re.diff re.allchar (str.to_re "\n")))))) (re.++ ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "F") (str.to_re "G")))) (re.++ (str.to_re "A") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "F") (re.diff re.allchar (str.to_re "\n")))))) (re.++ (str.to_re "A") (re.++ ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "G")))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "C") (re.++ (re.diff re.allchar (str.to_re "\n")) (str.to_re "G")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)