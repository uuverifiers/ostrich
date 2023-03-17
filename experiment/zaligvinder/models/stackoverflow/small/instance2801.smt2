;test regex strsplit("2015-05-13T20:41:29+0000",split="-\\d{2}T")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "s") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "2015") (re.++ (str.to_re "-") (re.++ (str.to_re "05") (re.++ (str.to_re "-") (re.++ (str.to_re "13") (re.++ (str.to_re "T") (re.++ (str.to_re "20") (re.++ (str.to_re ":") (re.++ (str.to_re "41") (re.++ (str.to_re ":") (re.++ (re.+ (str.to_re "29")) (re.++ (str.to_re "0000") (str.to_re "\u{22}")))))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re "s") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "-") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 2 2) (str.to_re "d")) (re.++ (str.to_re "T") (str.to_re "\u{22}"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)