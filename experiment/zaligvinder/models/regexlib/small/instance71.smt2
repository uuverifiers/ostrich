;test regex ^([A-Za-z]{6}[0-9lmnpqrstuvLMNPQRSTUV]{2}[abcdehlmprstABCDEHLMPRST]{1}[0-9lmnpqrstuvLMNPQRSTUV]{2}[A-Za-z]{1}[0-9lmnpqrstuvLMNPQRSTUV]{3}[A-Za-z]{1})|([0-9]{11})$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ ((_ re.loop 6 6) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.union (str.to_re "l") (re.union (str.to_re "m") (re.union (str.to_re "n") (re.union (str.to_re "p") (re.union (str.to_re "q") (re.union (str.to_re "r") (re.union (str.to_re "s") (re.union (str.to_re "t") (re.union (str.to_re "u") (re.union (str.to_re "v") (re.union (str.to_re "L") (re.union (str.to_re "M") (re.union (str.to_re "N") (re.union (str.to_re "P") (re.union (str.to_re "Q") (re.union (str.to_re "R") (re.union (str.to_re "S") (re.union (str.to_re "T") (re.union (str.to_re "U") (str.to_re "V")))))))))))))))))))))) (re.++ ((_ re.loop 1 1) (re.union (str.to_re "a") (re.union (str.to_re "b") (re.union (str.to_re "c") (re.union (str.to_re "d") (re.union (str.to_re "e") (re.union (str.to_re "h") (re.union (str.to_re "l") (re.union (str.to_re "m") (re.union (str.to_re "p") (re.union (str.to_re "r") (re.union (str.to_re "s") (re.union (str.to_re "t") (re.union (str.to_re "A") (re.union (str.to_re "B") (re.union (str.to_re "C") (re.union (str.to_re "D") (re.union (str.to_re "E") (re.union (str.to_re "H") (re.union (str.to_re "L") (re.union (str.to_re "M") (re.union (str.to_re "P") (re.union (str.to_re "R") (re.union (str.to_re "S") (str.to_re "T"))))))))))))))))))))))))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.union (str.to_re "l") (re.union (str.to_re "m") (re.union (str.to_re "n") (re.union (str.to_re "p") (re.union (str.to_re "q") (re.union (str.to_re "r") (re.union (str.to_re "s") (re.union (str.to_re "t") (re.union (str.to_re "u") (re.union (str.to_re "v") (re.union (str.to_re "L") (re.union (str.to_re "M") (re.union (str.to_re "N") (re.union (str.to_re "P") (re.union (str.to_re "Q") (re.union (str.to_re "R") (re.union (str.to_re "S") (re.union (str.to_re "T") (re.union (str.to_re "U") (str.to_re "V")))))))))))))))))))))) (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.union (str.to_re "l") (re.union (str.to_re "m") (re.union (str.to_re "n") (re.union (str.to_re "p") (re.union (str.to_re "q") (re.union (str.to_re "r") (re.union (str.to_re "s") (re.union (str.to_re "t") (re.union (str.to_re "u") (re.union (str.to_re "v") (re.union (str.to_re "L") (re.union (str.to_re "M") (re.union (str.to_re "N") (re.union (str.to_re "P") (re.union (str.to_re "Q") (re.union (str.to_re "R") (re.union (str.to_re "S") (re.union (str.to_re "T") (re.union (str.to_re "U") (str.to_re "V")))))))))))))))))))))) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z")))))))))) (re.++ ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)