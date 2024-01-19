;test regex (\d{1,5})\/(tcp|udp)[ \t]+open[ \t]+(\S+)[ \t]+(.*)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 5) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ (re.union (re.++ (str.to_re "t") (re.++ (str.to_re "c") (str.to_re "p"))) (re.++ (str.to_re "u") (re.++ (str.to_re "d") (str.to_re "p")))) (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}"))) (re.++ (str.to_re "o") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}"))) (re.++ (re.+ (re.inter (re.diff re.allchar (str.to_re "\u{20}")) (re.inter (re.diff re.allchar (str.to_re "\u{0a}")) (re.inter (re.diff re.allchar (str.to_re "\u{0b}")) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.inter (re.diff re.allchar (str.to_re "\u{09}")) (re.diff re.allchar (str.to_re "\u{0c}")))))))) (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}"))) (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)