;test regex ^\n*[uU][sS][eE][rR][\u{20}\u{09}\u{0b}][^\n]{49}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (str.to_re "\u{0a}")) (re.++ (re.union (str.to_re "u") (str.to_re "U")) (re.++ (re.union (str.to_re "s") (str.to_re "S")) (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.++ (re.union (str.to_re "r") (str.to_re "R")) (re.++ (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0b}"))) ((_ re.loop 49 49) (re.diff re.allchar (str.to_re "\u{0a}"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)