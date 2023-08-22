;test regex <PRE>\s*[^\n\r]{80,}.*?</PRE>
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "<") (re.++ (str.to_re "P") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re ">") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re "\u{0a}")) (re.diff re.allchar (str.to_re "\u{0d}")))) ((_ re.loop 80 80) (re.inter (re.diff re.allchar (str.to_re "\u{0a}")) (re.diff re.allchar (str.to_re "\u{0d}"))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "P") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (str.to_re ">"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)