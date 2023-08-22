;test regex :\s?([5-9]\d\d|1\d{3}|2000)\s?(m3|\n)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re ":") (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.union (re.union (re.++ (re.range "5" "9") (re.++ (re.range "0" "9") (re.range "0" "9"))) (re.++ (str.to_re "1") ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "2000")) (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.union (re.++ (str.to_re "m") (str.to_re "3")) (str.to_re "\u{0a}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)