(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|11|12|10)-(19[0-9]{2})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (str.to_re "11") (str.to_re "12") (str.to_re "10")) (str.to_re "-\u{0a}19") ((_ re.loop 2 2) (re.range "0" "9"))))))
; name\u{2e}cnnic\u{2e}cn\x2Fbar_pl\x2Fchk_bar\.fcgiHost\x3A\x7CConnected
(assert (not (str.in_re X (str.to_re "name.cnnic.cn/bar_pl/chk_bar.fcgiHost:|Connected\u{0a}"))))
; /Content-Disposition\u{3a}\u{20}inline\u{3b}[^\u{0d}\u{0a}]filename=[a-z]{5,8}\d{2,3}\.pdf\u{0d}\u{0a}/Hm
(assert (not (str.in_re X (re.++ (str.to_re "/Content-Disposition: inline;") (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}")) (str.to_re "filename=") ((_ re.loop 5 8) (re.range "a" "z")) ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".pdf\u{0d}\u{0a}/Hm\u{0a}")))))
; /\u{2e}bmp([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.bmp") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
