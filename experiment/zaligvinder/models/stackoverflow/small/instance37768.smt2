;test regex $regex = '~ABC[0-9]{4}_ABCDEfghi_([0-9]{8})[0-9]{6}\.mp4~';
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "~") (re.++ (str.to_re "A") (re.++ (str.to_re "B") (re.++ (str.to_re "C") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (str.to_re "A") (re.++ (str.to_re "B") (re.++ (str.to_re "C") (re.++ (str.to_re "D") (re.++ (str.to_re "E") (re.++ (str.to_re "f") (re.++ (str.to_re "g") (re.++ (str.to_re "h") (re.++ (str.to_re "i") (re.++ (str.to_re "_") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (str.to_re "m") (re.++ (str.to_re "p") (re.++ (str.to_re "4") (re.++ (str.to_re "~") (re.++ (str.to_re "\u{27}") (str.to_re ";")))))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)