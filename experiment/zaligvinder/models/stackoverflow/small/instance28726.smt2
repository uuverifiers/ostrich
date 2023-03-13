;test regex JPRN(JAPICCTI\d{6})|(JAPICCTI\d{6})
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "J") (re.++ (str.to_re "P") (re.++ (str.to_re "R") (re.++ (str.to_re "N") (re.++ (str.to_re "J") (re.++ (str.to_re "A") (re.++ (str.to_re "P") (re.++ (str.to_re "I") (re.++ (str.to_re "C") (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (str.to_re "I") ((_ re.loop 6 6) (re.range "0" "9")))))))))))))) (re.++ (str.to_re "J") (re.++ (str.to_re "A") (re.++ (str.to_re "P") (re.++ (str.to_re "I") (re.++ (str.to_re "C") (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (str.to_re "I") ((_ re.loop 6 6) (re.range "0" "9")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)