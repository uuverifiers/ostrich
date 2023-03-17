;test regex (\\d{4}\\s+[a-zA-Z]{2}\\s+PLAIN\\sTEXT\\s+)?(\\w+)(\\s+\\(NS\\))?
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "\\") (re.++ ((_ re.loop 4 4) (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "s")) (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "s")) (re.++ (str.to_re "P") (re.++ (str.to_re "L") (re.++ (str.to_re "A") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.++ (str.to_re "T") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "T") (re.++ (str.to_re "\\") (re.+ (str.to_re "s")))))))))))))))))))))) (re.++ (re.++ (str.to_re "\\") (re.+ (str.to_re "w"))) (re.opt (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "s")) (re.++ (str.to_re "\\") (re.++ (str.to_re "N") (re.++ (str.to_re "S") (str.to_re "\\")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)