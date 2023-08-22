;test regex REGEXP_EXTRACT([resolution],'(\d{2}:\d{2})')
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "P") (re.++ (str.to_re "_") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "T") (re.++ (str.to_re "R") (re.++ (str.to_re "A") (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (re.union (str.to_re "r") (re.union (str.to_re "e") (re.union (str.to_re "s") (re.union (str.to_re "o") (re.union (str.to_re "l") (re.union (str.to_re "u") (re.union (str.to_re "t") (re.union (str.to_re "i") (re.union (str.to_re "o") (str.to_re "n")))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{27}") (re.++ (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re ":") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{27}")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)