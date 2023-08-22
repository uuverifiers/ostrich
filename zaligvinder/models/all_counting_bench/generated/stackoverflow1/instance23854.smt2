;test regex ([0-9]{6}|\*[0-9][0-9\*]{0,4}|[0-9]\*[0-9\*]{0,4}|[0-9]{2}\*[0-9\*]{0,3}|[0-9]{3}\*[0-9\*]{0,2}|[0-9]{4}\*[0-9\*]?|[0-9]{5}\*)
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (str.to_re "*") (re.++ (re.range "0" "9") ((_ re.loop 0 4) (re.union (re.range "0" "9") (str.to_re "*")))))) (re.++ (re.range "0" "9") (re.++ (str.to_re "*") ((_ re.loop 0 4) (re.union (re.range "0" "9") (str.to_re "*")))))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "*") ((_ re.loop 0 3) (re.union (re.range "0" "9") (str.to_re "*")))))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "*") ((_ re.loop 0 2) (re.union (re.range "0" "9") (str.to_re "*")))))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "*") (re.opt (re.union (re.range "0" "9") (str.to_re "*")))))) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "*")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)