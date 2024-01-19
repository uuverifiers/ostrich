;test regex /^(0?\d|1[0-2])\/([0-2]?\d|3[01])\/(\d{1,4})\s([01]?\d|2[0-3]):([0-5]?\d):([0-5]?\d)$/
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.++ (str.to_re "/") (re.++ (re.union (re.++ (re.opt (re.range "0" "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (str.to_re "01"))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 1 4) (re.range "0" "9")) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ (re.union (re.++ (re.opt (str.to_re "01")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.++ (str.to_re ":") (re.++ (re.++ (re.opt (re.range "0" "5")) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ (re.opt (re.range "0" "5")) (re.range "0" "9")))))))))))))) (re.++ (str.to_re "") (str.to_re "/")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)