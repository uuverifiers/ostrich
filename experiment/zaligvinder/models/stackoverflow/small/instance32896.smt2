;test regex searchString: "([0-9]{1}[\\.\\s][\\s\\D]?[^<]*?)(\\\\d\\.\\d\\d[^<])"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "S") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (re.union (str.to_re "\\") (re.union (str.to_re ".") (re.union (str.to_re "\\") (str.to_re "s")))) (re.++ (re.opt (re.union (str.to_re "\\") (re.union (str.to_re "s") (re.union (str.to_re "\\") (str.to_re "D"))))) (re.* (re.diff re.allchar (str.to_re "<")))))) (re.++ (re.++ (str.to_re "\\") (re.++ (str.to_re "\\") (re.++ (str.to_re "d") (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") (re.++ (str.to_re "d") (re.++ (str.to_re "\\") (re.++ (str.to_re "d") (re.diff re.allchar (str.to_re "<"))))))))))) (str.to_re "\u{22}"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)