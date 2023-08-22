;test regex /([\r\n])|(?:\[([a-z\*]{1,16})(?:="([^\u{00}-\x1F"'\(\)<>\[\]]{1,256})")?\])|(?:\[\/([a-z]{1,16})\])/gi
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "/") (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (re.++ (str.to_re "[") (re.++ ((_ re.loop 1 16) (re.union (re.range "a" "z") (str.to_re "*"))) (re.++ (re.opt (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 1 256) (re.inter (re.diff re.allchar (re.range "\u{00}" "\u{1f}")) (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.inter (re.diff re.allchar (str.to_re "\u{27}")) (re.inter (re.diff re.allchar (str.to_re "(")) (re.inter (re.diff re.allchar (str.to_re ")")) (re.inter (re.diff re.allchar (str.to_re "<")) (re.inter (re.diff re.allchar (str.to_re ">")) (re.inter (re.diff re.allchar (str.to_re "[")) (re.diff re.allchar (str.to_re "]"))))))))))) (str.to_re "\u{22}"))))) (str.to_re "]"))))) (re.++ (re.++ (str.to_re "[") (re.++ (str.to_re "/") (re.++ ((_ re.loop 1 16) (re.range "a" "z")) (str.to_re "]")))) (re.++ (str.to_re "/") (re.++ (str.to_re "g") (str.to_re "i")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)