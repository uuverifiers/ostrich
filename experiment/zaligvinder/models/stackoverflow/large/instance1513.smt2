;test regex $this_string = '{95}1340{113}1488{116}1545{99}1364';
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "i") (re.++ (str.to_re "s") (re.++ (str.to_re "_") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ ((_ re.loop 95 95) (str.to_re "\u{27}")) (re.++ ((_ re.loop 113 113) (str.to_re "1340")) (re.++ ((_ re.loop 116 116) (str.to_re "1488")) (re.++ ((_ re.loop 99 99) (str.to_re "1545")) (re.++ (str.to_re "1364") (re.++ (str.to_re "\u{27}") (str.to_re ";"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)