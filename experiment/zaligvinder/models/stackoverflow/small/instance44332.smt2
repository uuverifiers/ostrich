;test regex s1,s2,s3,([^ ,]+,){17}s21,[^ ,]+,s23,s24
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "s") (str.to_re "1")) (re.++ (str.to_re ",") (re.++ (str.to_re "s") (str.to_re "2")))) (re.++ (str.to_re ",") (re.++ (str.to_re "s") (str.to_re "3")))) (re.++ (str.to_re ",") (re.++ ((_ re.loop 17 17) (re.++ (re.+ (re.inter (re.diff re.allchar (str.to_re " ")) (re.diff re.allchar (str.to_re ",")))) (str.to_re ","))) (re.++ (str.to_re "s") (str.to_re "21"))))) (re.++ (str.to_re ",") (re.+ (re.inter (re.diff re.allchar (str.to_re " ")) (re.diff re.allchar (str.to_re ",")))))) (re.++ (str.to_re ",") (re.++ (str.to_re "s") (str.to_re "23")))) (re.++ (str.to_re ",") (re.++ (str.to_re "s") (str.to_re "24"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)