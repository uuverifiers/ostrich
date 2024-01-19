;test regex ("( {9}time)(.+)(c1xx\\.dll+)(.+)")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.++ ((_ re.loop 9 9) (str.to_re " ")) (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "m") (str.to_re "e"))))) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (str.to_re "c") (re.++ (str.to_re "1") (re.++ (str.to_re "x") (re.++ (str.to_re "x") (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "d") (re.++ (str.to_re "l") (re.+ (str.to_re "l")))))))))) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{22}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)