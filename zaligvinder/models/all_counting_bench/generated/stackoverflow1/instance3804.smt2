;test regex \< *[img][^\>]*src *= *[\"\']{0,1}([^\"\'\ >]*)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "<") (re.++ (re.* (str.to_re " ")) (re.++ (re.union (str.to_re "i") (re.union (str.to_re "m") (str.to_re "g"))) (re.++ (re.* (re.diff re.allchar (str.to_re ">"))) (re.++ (str.to_re "s") (re.++ (str.to_re "r") (re.++ (str.to_re "c") (re.++ (re.* (str.to_re " ")) (re.++ (str.to_re "=") (re.++ (re.* (str.to_re " ")) (re.++ ((_ re.loop 0 1) (re.union (str.to_re "\u{22}") (str.to_re "\u{27}"))) (re.* (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.inter (re.diff re.allchar (str.to_re "\u{27}")) (re.inter (re.diff re.allchar (str.to_re " ")) (re.diff re.allchar (str.to_re ">")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)