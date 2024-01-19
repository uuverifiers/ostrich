;test regex gsub('([0-9]{2})/([0-9]{2})/([0-9]{2})', '\\1-\\2-20\\3', '25/08/14')
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "g") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (str.to_re "\u{27}") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{27}"))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "\\") (re.++ (str.to_re "1") (re.++ (str.to_re "-") (re.++ (str.to_re "\\") (re.++ (str.to_re "2") (re.++ (str.to_re "-") (re.++ (str.to_re "20") (re.++ (str.to_re "\\") (re.++ (str.to_re "3") (str.to_re "\u{27}")))))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "25") (re.++ (str.to_re "/") (re.++ (str.to_re "08") (re.++ (str.to_re "/") (re.++ (str.to_re "14") (str.to_re "\u{27}"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)