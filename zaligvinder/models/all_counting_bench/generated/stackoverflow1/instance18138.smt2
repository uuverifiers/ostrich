;test regex gsub("([A-Za-z]+)(10|11)?(?:(\\d)(\\d))?([0-9]{0,1}?)$","\\1\\3\\.\\2\\4\\5",u)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "g") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (re.opt (re.union (str.to_re "10") (str.to_re "11"))) (re.++ (re.opt (re.++ (re.++ (str.to_re "\\") (str.to_re "d")) (re.++ (str.to_re "\\") (str.to_re "d")))) ((_ re.loop 0 1) (re.range "0" "9")))))) (re.++ (str.to_re "") (str.to_re "\u{22}"))) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (str.to_re "1") (re.++ (str.to_re "\\") (re.++ (str.to_re "3") (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") (re.++ (str.to_re "2") (re.++ (str.to_re "\\") (re.++ (str.to_re "4") (re.++ (str.to_re "\\") (re.++ (str.to_re "5") (str.to_re "\u{22}")))))))))))))))) (re.++ (str.to_re ",") (str.to_re "u")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)