;test regex ^([a-zA-Z]:\\)?[^\u{00}-\x1F&quot;<>\|:\*\?/]+\.[a-zA-Z]{3,4}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.++ (str.to_re ":") (str.to_re "\\")))) (re.++ (re.+ (re.inter (re.diff re.allchar (re.range "\u{00}" "\u{1f}")) (re.inter (re.diff re.allchar (str.to_re "&")) (re.inter (re.diff re.allchar (str.to_re "q")) (re.inter (re.diff re.allchar (str.to_re "u")) (re.inter (re.diff re.allchar (str.to_re "o")) (re.inter (re.diff re.allchar (str.to_re "t")) (re.inter (re.diff re.allchar (str.to_re ";")) (re.inter (re.diff re.allchar (str.to_re "<")) (re.inter (re.diff re.allchar (str.to_re ">")) (re.inter (re.diff re.allchar (str.to_re "|")) (re.inter (re.diff re.allchar (str.to_re ":")) (re.inter (re.diff re.allchar (str.to_re "*")) (re.inter (re.diff re.allchar (str.to_re "?")) (re.diff re.allchar (str.to_re "/")))))))))))))))) (re.++ (str.to_re ".") ((_ re.loop 3 4) (re.union (re.range "a" "z") (re.range "A" "Z"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)