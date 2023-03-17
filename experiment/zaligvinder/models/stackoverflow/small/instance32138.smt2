;test regex "^((\\([2-9]\\d{2}\\)|[2-9]\\d{2})(-\\d{3}-\\d{4}|\\.\\d{3}\\.\\d{4})([Xx] ?\\d{1,4})?)$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "\\") (re.++ (re.range "2" "9") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 2 2) (str.to_re "d")) (str.to_re "\\"))))) (re.++ (re.range "2" "9") (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d"))))) (re.++ (re.union (re.++ (str.to_re "-") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 3 3) (str.to_re "d")) (re.++ (str.to_re "-") (re.++ (str.to_re "\\") ((_ re.loop 4 4) (str.to_re "d"))))))) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 3 3) (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") ((_ re.loop 4 4) (str.to_re "d")))))))))) (re.opt (re.++ (re.union (str.to_re "X") (str.to_re "x")) (re.++ (re.opt (str.to_re " ")) (re.++ (str.to_re "\\") ((_ re.loop 1 4) (str.to_re "d")))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)