;test regex ^(?:(?:(?:200|(?:(?:[1-9]\d?)|(?:1\d{0,2}))(?:\.\d+)?)pt)|(?:(?:7|(?:[1-6](?:\.\d+)?)|(?:0\.(?:0[5-9]|[1-9])(?:\d+)?))cm))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.union (str.to_re "200") (re.++ (re.union (re.++ (re.range "1" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "1") ((_ re.loop 0 2) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))))) (re.++ (str.to_re "p") (str.to_re "t"))) (re.++ (re.union (re.union (str.to_re "7") (re.++ (re.range "1" "6") (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))))) (re.++ (str.to_re "0") (re.++ (str.to_re ".") (re.++ (re.union (re.++ (str.to_re "0") (re.range "5" "9")) (re.range "1" "9")) (re.opt (re.+ (re.range "0" "9"))))))) (re.++ (str.to_re "c") (str.to_re "m"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)