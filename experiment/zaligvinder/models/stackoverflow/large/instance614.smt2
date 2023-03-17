;test regex ^((.+\n){0,4}.+|.{1,375})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ ((_ re.loop 0 4) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{0a}"))) (re.+ (re.diff re.allchar (str.to_re "\n")))) ((_ re.loop 1 375) (re.diff re.allchar (str.to_re "\n"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)