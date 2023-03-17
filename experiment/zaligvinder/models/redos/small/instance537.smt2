;test regex http://file\d+\.agesage\.jp/flv/\d{8}/\d{10}_\d{6}\.flv
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.++ (str.to_re ":") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re ".") (re.++ (str.to_re "j") (re.++ (str.to_re "p") (re.++ (str.to_re "/") (re.++ (str.to_re "f") (re.++ (str.to_re "l") (re.++ (str.to_re "v") (re.++ (str.to_re "/") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (str.to_re "f") (re.++ (str.to_re "l") (str.to_re "v")))))))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)