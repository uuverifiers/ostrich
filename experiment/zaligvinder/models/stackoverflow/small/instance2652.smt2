;test regex <a.*?href=["']{1}.*?\.asp["']{1}.*?>.*?<\/a>
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "<") (re.++ (str.to_re "a") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "h") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (str.to_re "=") (re.++ ((_ re.loop 1 1) (re.union (str.to_re "\u{22}") (str.to_re "\u{27}"))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ".") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "p") (re.++ ((_ re.loop 1 1) (re.union (str.to_re "\u{22}") (str.to_re "\u{27}"))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ">") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "a") (str.to_re ">"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)