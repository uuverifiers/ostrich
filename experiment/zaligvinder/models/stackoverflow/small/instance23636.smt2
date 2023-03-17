;test regex $re = "#href=[\"']?(\d{4}(?:[-_]\d{2})+)[\"']?#";
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "#") (re.++ (str.to_re "h") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (str.to_re "=") (re.++ (re.opt (re.union (str.to_re "\u{22}") (str.to_re "\u{27}"))) (re.++ (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.+ (re.++ (re.union (str.to_re "-") (str.to_re "_")) ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (re.opt (re.union (str.to_re "\u{22}") (str.to_re "\u{27}"))) (re.++ (str.to_re "#") (re.++ (str.to_re "\u{22}") (str.to_re ";")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)