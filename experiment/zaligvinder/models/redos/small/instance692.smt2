;test regex Current IPTC Digest: (0|#){32}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "C") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "I") (re.++ (str.to_re "P") (re.++ (str.to_re "T") (re.++ (str.to_re "C") (re.++ (str.to_re " ") (re.++ (str.to_re "D") (re.++ (str.to_re "i") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re ":") (re.++ (str.to_re " ") ((_ re.loop 32 32) (re.union (str.to_re "0") (str.to_re "#"))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)