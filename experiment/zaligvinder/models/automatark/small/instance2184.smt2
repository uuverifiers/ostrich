(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([4]{1})([0-9]{12,15})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "4")) ((_ re.loop 12 15) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; User-Agent\u{3a}etbuviaebe\u{2f}eqv\.bvv
(assert (str.in_re X (str.to_re "User-Agent:etbuviaebe/eqv.bvv\u{0a}")))
; name\u{2e}cnnic\u{2e}cn\scom\x2Findex\.php\?tpid=\s\x5BStatic.*\x2Fbar_pl\x2Fb\.fcgi
(assert (str.in_re X (re.++ (str.to_re "name.cnnic.cn") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "com/index.php?tpid=") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "[Static") (re.* re.allchar) (str.to_re "/bar_pl/b.fcgi\u{0a}"))))
(check-sat)
