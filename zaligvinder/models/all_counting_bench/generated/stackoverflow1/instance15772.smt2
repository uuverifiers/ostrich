;test regex \d{4}-[01]{1}\d{1}-[0-3]{1}\d{1}T[0-2]{1}\d{1}:[0-6]{1}\d{1}:[0-6]{1}\d{1}Z
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 1 1) (str.to_re "01")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 1 1) (re.range "0" "3")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (str.to_re "T") (re.++ ((_ re.loop 1 1) (re.range "0" "2")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 1 1) (re.range "0" "6")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 1 1) (re.range "0" "6")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "Z")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)