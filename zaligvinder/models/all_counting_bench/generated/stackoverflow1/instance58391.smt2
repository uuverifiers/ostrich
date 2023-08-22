;test regex /^([A-Z])|([0-9]+)(.([0-9]<b>{1,2}</b>))?$/i;
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.range "A" "Z"))) (re.++ (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.range "0" "9") (re.++ (str.to_re "<") (re.++ (str.to_re "b") (re.++ ((_ re.loop 1 2) (str.to_re ">")) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "b") (str.to_re ">"))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ (str.to_re "i") (str.to_re ";"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)