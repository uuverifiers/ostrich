;test regex ([A-PR-UWYZ](?:(?:\d{1,2}|\d[A-HJ-KSTUW])|(?:[A-HK-Y]\d(?:\d|[A-Z])?)))
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.range "A" "P") (re.union (re.range "R" "U") (re.union (str.to_re "W") (re.union (str.to_re "Y") (str.to_re "Z"))))) (re.union (re.union ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.range "0" "9") (re.union (re.range "A" "H") (re.union (re.range "J" "K") (re.union (str.to_re "S") (re.union (str.to_re "T") (re.union (str.to_re "U") (str.to_re "W")))))))) (re.++ (re.union (re.range "A" "H") (re.range "K" "Y")) (re.++ (re.range "0" "9") (re.opt (re.union (re.range "0" "9") (re.range "A" "Z")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)