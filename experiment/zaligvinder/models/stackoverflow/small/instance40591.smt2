;test regex regexp_replace(to_char(field,'FM000,000,000'),$$^(0{1,3},?)+$$,'&#x2007;')
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "p") (re.++ (str.to_re "_") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "t") (re.++ (str.to_re "o") (re.++ (str.to_re "_") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (re.++ (re.++ (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (str.to_re "d"))))) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "F") (re.++ (str.to_re "M") (str.to_re "000")))))) (re.++ (str.to_re ",") (str.to_re "000"))) (re.++ (str.to_re ",") (re.++ (str.to_re "000") (str.to_re "\u{27}"))))))))))) (str.to_re ",")) (str.to_re "")) (str.to_re "")) (re.++ (str.to_re "") (re.+ (re.++ ((_ re.loop 1 3) (str.to_re "0")) (re.opt (str.to_re ",")))))) (str.to_re "")) (str.to_re "")) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "&") (re.++ (str.to_re "#") (re.++ (str.to_re "x") (re.++ (str.to_re "2007") (re.++ (str.to_re ";") (str.to_re "\u{27}")))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)