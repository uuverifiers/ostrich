;test regex [A-Z][a-z]{2}\\s[A-Z][a-z]{2}\\s[0-9]{2}\\s[0-9]{2}:[0-9]{2}:[0-9]{2}\\s[A-Z]{3}\\s[0-9]{4}
(declare-const X String)
(assert (str.in_re X (re.++ (re.range "A" "Z") (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.++ (re.range "A" "Z") (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (re.++ (str.to_re "\\") (re.++ (str.to_re "s") ((_ re.loop 4 4) (re.range "0" "9")))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)