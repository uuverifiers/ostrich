;test regex (<div.*?>)+.*?(</div>){3}
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.++ (str.to_re "<") (re.++ (str.to_re "d") (re.++ (str.to_re "i") (re.++ (str.to_re "v") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re ">"))))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 3 3) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "d") (re.++ (str.to_re "i") (re.++ (str.to_re "v") (str.to_re ">")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)