;test regex (?:site(?:\\.com)?[\\s\\w\\d^]*)(\\d+\\.\\d{2})
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "s") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (re.opt (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m")))))) (re.* (re.union (str.to_re "\\") (re.union (str.to_re "s") (re.union (str.to_re "\\") (re.union (str.to_re "w") (re.union (str.to_re "\\") (re.union (str.to_re "d") (str.to_re "^"))))))))))))) (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)