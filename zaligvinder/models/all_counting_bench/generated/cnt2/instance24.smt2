;test regex ^\n*[fF][iI][lL][eE]\u{3a}\u{2f}\u{2f}[^\n]{400}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (str.to_re "\u{0a}")) (re.++ (re.union (str.to_re "f") (str.to_re "F")) (re.++ (re.union (str.to_re "i") (str.to_re "I")) (re.++ (re.union (str.to_re "l") (str.to_re "L")) (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.++ (str.to_re "\u{3a}") (re.++ (str.to_re "\u{2f}") (re.++ (str.to_re "\u{2f}") ((_ re.loop 400 400) (re.diff re.allchar (str.to_re "\u{0a}"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)