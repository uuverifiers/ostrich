;test regex sed -e "s/([0-9]+/[0-9]+[,]{0,1})|([0-9]+[,]{0,1})/st\.\ &1&2/g"
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ (re.+ (re.range "0" "9")) ((_ re.loop 0 1) (str.to_re ","))))))))))))))) (re.++ (re.++ (re.+ (re.range "0" "9")) ((_ re.loop 0 1) (str.to_re ","))) (re.++ (str.to_re "/") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re ".") (re.++ (str.to_re " ") (re.++ (str.to_re "&") (re.++ (str.to_re "1") (re.++ (str.to_re "&") (re.++ (str.to_re "2") (re.++ (str.to_re "/") (re.++ (str.to_re "g") (str.to_re "\u{22}"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)