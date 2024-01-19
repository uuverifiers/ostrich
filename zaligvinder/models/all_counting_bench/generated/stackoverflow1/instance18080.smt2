;test regex cast([^\n]+\n){0,2}[^\n]*datetime
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ ((_ re.loop 0 2) (re.++ (re.+ (re.diff re.allchar (str.to_re "\u{0a}"))) (str.to_re "\u{0a}"))) (re.++ (re.* (re.diff re.allchar (str.to_re "\u{0a}"))) (re.++ (str.to_re "d") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "m") (str.to_re "e"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)