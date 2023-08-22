;test regex s/(^.{20})(\S*)  /$1"$2"/;
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (re.++ (str.to_re "") ((_ re.loop 20 20) (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re "\u{20}")) (re.inter (re.diff re.allchar (str.to_re "\u{0a}")) (re.inter (re.diff re.allchar (str.to_re "\u{0b}")) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.inter (re.diff re.allchar (str.to_re "\u{09}")) (re.diff re.allchar (str.to_re "\u{0c}")))))))) (re.++ (str.to_re " ") (re.++ (str.to_re " ") (str.to_re "/"))))))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (str.to_re "\u{22}")))) (re.++ (str.to_re "") (re.++ (str.to_re "2") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "/") (str.to_re ";"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)