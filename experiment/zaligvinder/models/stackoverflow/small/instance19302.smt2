;test regex ^([A-Za-z. ]+[^<])(<[A-Z]{4}>)?(\r?\n?)([A-z].*)(\r?\n?)([A-z].*)(\r?\n?){1}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.++ (re.+ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (str.to_re ".") (str.to_re " "))))) (re.diff re.allchar (str.to_re "<"))) (re.++ (re.opt (re.++ (str.to_re "<") (re.++ ((_ re.loop 4 4) (re.range "A" "Z")) (str.to_re ">")))) (re.++ (re.++ (re.opt (str.to_re "\u{0d}")) (re.opt (str.to_re "\u{0a}"))) (re.++ (re.++ (re.range "A" "z") (re.* (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.++ (re.opt (str.to_re "\u{0d}")) (re.opt (str.to_re "\u{0a}"))) (re.++ (re.++ (re.range "A" "z") (re.* (re.diff re.allchar (str.to_re "\n")))) ((_ re.loop 1 1) (re.++ (re.opt (str.to_re "\u{0d}")) (re.opt (str.to_re "\u{0a}")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)