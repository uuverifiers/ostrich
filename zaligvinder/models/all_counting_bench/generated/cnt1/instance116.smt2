;test regex (\d{6})((?:C|D)R?)([0-9,]{15})(N\d{3}|NMSC)([0-9P ]{16})
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (re.++ (re.union (str.to_re "C") (str.to_re "D")) (re.opt (str.to_re "R"))) (re.++ ((_ re.loop 15 15) (re.union (re.range "0" "9") (str.to_re ","))) (re.++ (re.union (re.++ (str.to_re "N") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "N") (re.++ (str.to_re "M") (re.++ (str.to_re "S") (str.to_re "C"))))) ((_ re.loop 16 16) (re.union (re.range "0" "9") (re.union (str.to_re "P") (str.to_re " "))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)