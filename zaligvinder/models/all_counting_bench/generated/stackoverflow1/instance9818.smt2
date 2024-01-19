;test regex /(\d\d?)\/(\d\d?)\/(\d{2,4})(?: (\d\d?):(\d\d?)([ap]m))?/i
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ (re.++ (re.range "0" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "/") (re.++ (re.++ (re.range "0" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 4) (re.range "0" "9")) (re.++ (re.opt (re.++ (str.to_re " ") (re.++ (re.++ (re.range "0" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re ":") (re.++ (re.++ (re.range "0" "9") (re.opt (re.range "0" "9"))) (re.++ (re.union (str.to_re "a") (str.to_re "p")) (str.to_re "m"))))))) (re.++ (str.to_re "/") (str.to_re "i")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)