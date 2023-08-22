;test regex ^((?:[^,\r\n]*?,){30})((?:[^,\r\n]*?,){15}[^,]*?),((?:[^,\r\n]*?,){6}[^,\r\n]*)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 30 30) (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re ",")) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}"))))) (str.to_re ","))) (re.++ ((_ re.loop 15 15) (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re ",")) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}"))))) (str.to_re ","))) (re.* (re.diff re.allchar (str.to_re ",")))))) (re.++ (str.to_re ",") (re.++ ((_ re.loop 6 6) (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re ",")) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}"))))) (str.to_re ","))) (re.* (re.inter (re.diff re.allchar (str.to_re ",")) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)