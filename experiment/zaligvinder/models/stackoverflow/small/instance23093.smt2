;test regex ^(\d|\d{1,9}|1\d{1,9}|20\d{8}|213\d{7}|2146\d{6}|21473\d{5}|214747\d{4}|2147482\d{3}|21474835\d{2}|214748364[0-7])$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.range "0" "9") ((_ re.loop 1 9) (re.range "0" "9"))) (re.++ (str.to_re "1") ((_ re.loop 1 9) (re.range "0" "9")))) (re.++ (str.to_re "20") ((_ re.loop 8 8) (re.range "0" "9")))) (re.++ (str.to_re "213") ((_ re.loop 7 7) (re.range "0" "9")))) (re.++ (str.to_re "2146") ((_ re.loop 6 6) (re.range "0" "9")))) (re.++ (str.to_re "21473") ((_ re.loop 5 5) (re.range "0" "9")))) (re.++ (str.to_re "214747") ((_ re.loop 4 4) (re.range "0" "9")))) (re.++ (str.to_re "2147482") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "21474835") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "214748364") (re.range "0" "7")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)