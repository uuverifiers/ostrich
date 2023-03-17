;test regex ^([^\/:*<>|]{1,20}:)?(\$DCC2\$10240#[^\/:*<>|]{1,20}#)?[a-f0-9]{32}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.++ ((_ re.loop 1 20) (re.inter (re.diff re.allchar (str.to_re "/")) (re.inter (re.diff re.allchar (str.to_re ":")) (re.inter (re.diff re.allchar (str.to_re "*")) (re.inter (re.diff re.allchar (str.to_re "<")) (re.inter (re.diff re.allchar (str.to_re ">")) (re.diff re.allchar (str.to_re "|")))))))) (str.to_re ":"))) (re.++ (re.opt (re.++ (str.to_re "$") (re.++ (str.to_re "D") (re.++ (str.to_re "C") (re.++ (str.to_re "C") (re.++ (str.to_re "2") (re.++ (str.to_re "$") (re.++ (str.to_re "10240") (re.++ (str.to_re "#") (re.++ ((_ re.loop 1 20) (re.inter (re.diff re.allchar (str.to_re "/")) (re.inter (re.diff re.allchar (str.to_re ":")) (re.inter (re.diff re.allchar (str.to_re "*")) (re.inter (re.diff re.allchar (str.to_re "<")) (re.inter (re.diff re.allchar (str.to_re ">")) (re.diff re.allchar (str.to_re "|")))))))) (str.to_re "#"))))))))))) ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)