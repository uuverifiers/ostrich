;test regex arn:aws:iam::((\d{12})|aws):policy/([a-zA-Z0-9-=,\.@_]{1,128})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re ":") (re.++ (str.to_re "a") (re.++ (str.to_re "w") (re.++ (str.to_re "s") (re.++ (str.to_re ":") (re.++ (str.to_re "i") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re ":") (re.++ (str.to_re ":") (re.++ (re.union ((_ re.loop 12 12) (re.range "0" "9")) (re.++ (str.to_re "a") (re.++ (str.to_re "w") (str.to_re "s")))) (re.++ (str.to_re ":") (re.++ (str.to_re "p") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "c") (re.++ (str.to_re "y") (re.++ (str.to_re "/") ((_ re.loop 1 128) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re "-") (re.union (str.to_re "=") (re.union (str.to_re ",") (re.union (str.to_re ".") (re.union (str.to_re "@") (str.to_re "_"))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)