;test regex SELECT '+79637434199' ~ '^((8|\+7)[\- ]?)(\(?\d{3}\)?[\- ]?)[\d\- ]{7,10}'
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "S") (re.++ (str.to_re "E") (re.++ (str.to_re "L") (re.++ (str.to_re "E") (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (str.to_re " ") (re.++ (re.+ (str.to_re "\u{27}")) (re.++ (str.to_re "79637434199") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re " ") (re.++ (str.to_re "~") (re.++ (str.to_re " ") (str.to_re "\u{27}")))))))))))))) (re.++ (str.to_re "") (re.++ (re.++ (re.union (str.to_re "8") (re.++ (str.to_re "+") (str.to_re "7"))) (re.opt (re.union (str.to_re "-") (str.to_re " ")))) (re.++ (re.++ (re.opt (str.to_re "(")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re " ")))))) (re.++ ((_ re.loop 7 10) (re.union (re.range "0" "9") (re.union (str.to_re "-") (str.to_re " ")))) (str.to_re "\u{27}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)