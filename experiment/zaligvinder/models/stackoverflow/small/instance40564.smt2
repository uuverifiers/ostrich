;test regex .*?(?:A(?:[\r\n]*[^\r\n]){5}[\r\n]*){4,}.*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (re.* (re.++ (str.to_re "A") (re.++ ((_ re.loop 5 5) (re.++ (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}"))))) (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}")))))) ((_ re.loop 4 4) (re.++ (str.to_re "A") (re.++ ((_ re.loop 5 5) (re.++ (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}"))))) (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))))))) (re.* (re.diff re.allchar (str.to_re "\n")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)