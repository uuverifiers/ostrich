;test regex ^([^\u{20}]{1,79})\u{20}(\u{20}|\u{20})\u{20}([^\u{20}]*)(.)[^\u{20}]*\u{20}(.*)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 79) (re.diff re.allchar (str.to_re "\u{20}"))) (re.++ (str.to_re "\u{20}") (re.++ (re.union (str.to_re "\u{20}") (str.to_re "\u{20}")) (re.++ (str.to_re "\u{20}") (re.++ (re.* (re.diff re.allchar (str.to_re "\u{20}"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.* (re.diff re.allchar (str.to_re "\u{20}"))) (re.++ (str.to_re "\u{20}") (re.* (re.diff re.allchar (str.to_re "\n")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)