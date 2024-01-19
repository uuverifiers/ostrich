;test regex (href|src){1}\=(\"|\'){1}(?:(?:\.\.\/)+)([a-z\.].{1,40}(?:\.com|\.pl)){1}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.++ (str.to_re "h") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (str.to_re "f")))) (re.++ (str.to_re "s") (re.++ (str.to_re "r") (str.to_re "c"))))) (re.++ (str.to_re "=") (re.++ ((_ re.loop 1 1) (re.union (str.to_re "\u{22}") (str.to_re "\u{27}"))) (re.++ (re.+ (re.++ (str.to_re ".") (re.++ (str.to_re ".") (str.to_re "/")))) ((_ re.loop 1 1) (re.++ (re.union (re.range "a" "z") (str.to_re ".")) (re.++ ((_ re.loop 1 40) (re.diff re.allchar (str.to_re "\n"))) (re.union (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m")))) (re.++ (str.to_re ".") (re.++ (str.to_re "p") (str.to_re "l")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)