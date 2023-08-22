;test regex ^,?([1-9][0-9]{0,2}|1000)(,\s*([1-9][0-9]{0,2}|1000))*,?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ (re.opt (str.to_re ",")) (re.++ (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9"))) (str.to_re "1000")) (re.* (re.++ (str.to_re ",") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9"))) (str.to_re "1000")))))))) (re.opt (str.to_re ","))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)