;test regex ^.*\u{0a}\u{55}\u{73}\u{65}\u{72}\u{2d}\u{41}\u{67}\u{65}\u{6e}\u{74}\u{3a}\u{20}.{10,90}Netscape\u{2f}7.*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re "\u{55}") (re.++ (str.to_re "\u{73}") (re.++ (str.to_re "\u{65}") (re.++ (str.to_re "\u{72}") (re.++ (str.to_re "\u{2d}") (re.++ (str.to_re "\u{41}") (re.++ (str.to_re "\u{67}") (re.++ (str.to_re "\u{65}") (re.++ (str.to_re "\u{6e}") (re.++ (str.to_re "\u{74}") (re.++ (str.to_re "\u{3a}") (re.++ (str.to_re "\u{20}") (re.++ ((_ re.loop 10 90) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "N") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re "s") (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re "\u{2f7}") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)