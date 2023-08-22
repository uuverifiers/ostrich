;test regex \*777\*[0-9]{10,}\*\d+\*(5|10|20|25|50|100)\*\d+#
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "*") (re.++ (str.to_re "777") (re.++ (str.to_re "*") (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 10 10) (re.range "0" "9"))) (re.++ (str.to_re "*") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "*") (re.++ (re.union (re.union (re.union (re.union (re.union (str.to_re "5") (str.to_re "10")) (str.to_re "20")) (str.to_re "25")) (str.to_re "50")) (str.to_re "100")) (re.++ (str.to_re "*") (re.++ (re.+ (re.range "0" "9")) (str.to_re "#")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)