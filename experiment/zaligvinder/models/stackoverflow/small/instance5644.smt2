;test regex (;[A-Z0-9]{5};[\\d]{1,};[\\d]{1,}\\.[\\d]{1,},?)+
(declare-const X String)
(assert (str.in_re X (re.+ (re.++ (re.++ (str.to_re ";") (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ (str.to_re ";") (re.++ (re.++ (re.* (re.union (str.to_re "\\") (str.to_re "d"))) ((_ re.loop 1 1) (re.union (str.to_re "\\") (str.to_re "d")))) (re.++ (str.to_re ";") (re.++ (re.++ (re.* (re.union (str.to_re "\\") (str.to_re "d"))) ((_ re.loop 1 1) (re.union (str.to_re "\\") (str.to_re "d")))) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.* (re.union (str.to_re "\\") (str.to_re "d"))) ((_ re.loop 1 1) (re.union (str.to_re "\\") (str.to_re "d")))))))))))) (re.opt (str.to_re ","))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)