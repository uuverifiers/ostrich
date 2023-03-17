;test regex href="https?://(w{3}|.+)(\..+)+(/.+)*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "h") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.++ (re.opt (str.to_re "s")) (re.++ (str.to_re ":") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (re.union ((_ re.loop 3 3) (str.to_re "w")) (re.+ (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.+ (re.++ (str.to_re ".") (re.+ (re.diff re.allchar (str.to_re "\n"))))) (re.* (re.++ (str.to_re "/") (re.+ (re.diff re.allchar (str.to_re "\n")))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)