;test regex regex <- '([:digit:]{8})_([:alnum:]{1,4})_([:upper:]+)_ etc'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (str.to_re "<") (re.++ (str.to_re "-") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ ((_ re.loop 8 8) (re.union (str.to_re ":") (re.union (str.to_re "d") (re.union (str.to_re "i") (re.union (str.to_re "g") (re.union (str.to_re "i") (re.union (str.to_re "t") (str.to_re ":")))))))) (re.++ (str.to_re "_") (re.++ ((_ re.loop 1 4) (re.union (str.to_re ":") (re.union (str.to_re "a") (re.union (str.to_re "l") (re.union (str.to_re "n") (re.union (str.to_re "u") (re.union (str.to_re "m") (str.to_re ":")))))))) (re.++ (str.to_re "_") (re.++ (re.+ (re.union (str.to_re ":") (re.union (str.to_re "u") (re.union (str.to_re "p") (re.union (str.to_re "p") (re.union (str.to_re "e") (re.union (str.to_re "r") (str.to_re ":")))))))) (re.++ (str.to_re "_") (re.++ (str.to_re " ") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (str.to_re "\u{27}")))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)