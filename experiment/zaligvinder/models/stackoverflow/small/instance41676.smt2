;test regex (\n{3}(.*)(?:\n{2}(.*)\n{1}(.*)\n{1}(.*))+)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (str.to_re "\u{0a}")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.+ (re.++ ((_ re.loop 2 2) (str.to_re "\u{0a}")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 1 1) (str.to_re "\u{0a}")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 1 1) (str.to_re "\u{0a}")) (re.* (re.diff re.allchar (str.to_re "\n")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)