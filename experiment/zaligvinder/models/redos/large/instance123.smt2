;test regex ^GET [^\r\n]*\x3F([^\r\n]*\u{26})*[^\x3D\r\n]{1025,}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "T") (re.++ (str.to_re " ") (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}")))) (re.++ (str.to_re "\u{3f}") (re.++ (re.* (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}")))) (str.to_re "\u{26}"))) (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re "\u{3d}")) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}"))))) ((_ re.loop 1025 1025) (re.inter (re.diff re.allchar (str.to_re "\u{3d}")) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)