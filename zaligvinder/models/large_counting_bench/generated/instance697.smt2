;test regex ^.{1080}(M\.K\.|M!K!|FLT4|FLT8|[5-9]CHN|[1-3][0-9]CH)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 1080 1080) (re.diff re.allchar (str.to_re "\n"))) (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "M") (re.++ (str.to_re ".") (re.++ (str.to_re "K") (str.to_re ".")))) (re.++ (str.to_re "M") (re.++ (str.to_re "!") (re.++ (str.to_re "K") (str.to_re "!"))))) (re.++ (str.to_re "F") (re.++ (str.to_re "L") (re.++ (str.to_re "T") (str.to_re "4"))))) (re.++ (str.to_re "F") (re.++ (str.to_re "L") (re.++ (str.to_re "T") (str.to_re "8"))))) (re.++ (re.range "5" "9") (re.++ (str.to_re "C") (re.++ (str.to_re "H") (str.to_re "N"))))) (re.++ (re.range "1" "3") (re.++ (re.range "0" "9") (re.++ (str.to_re "C") (str.to_re "H")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)