;test regex (000|111|222|333|444|555|666|777|888|999){2}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 2 2) (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "000") (str.to_re "111")) (str.to_re "222")) (str.to_re "333")) (str.to_re "444")) (str.to_re "555")) (str.to_re "666")) (str.to_re "777")) (str.to_re "888")) (str.to_re "999")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)