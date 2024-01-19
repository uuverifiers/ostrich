;test regex ((?:RA|SN|TS)(?:(?:B|E)(?:\d{2}|\d{4}))+)+
(declare-const X String)
(assert (str.in_re X (re.+ (re.++ (re.union (re.union (re.++ (str.to_re "R") (str.to_re "A")) (re.++ (str.to_re "S") (str.to_re "N"))) (re.++ (str.to_re "T") (str.to_re "S"))) (re.+ (re.++ (re.union (str.to_re "B") (str.to_re "E")) (re.union ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)