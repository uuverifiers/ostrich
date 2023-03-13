(declare-const X String)
; [0-7]+
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "7")) (str.to_re "\u{0a}")))))
; filename=\u{22}Subject\u{3a}www\x2Eadoptim\x2Ecomreport\x2Fbar_pl\x2Fchk\.fcgi
(assert (not (str.in_re X (str.to_re "filename=\u{22}Subject:www.adoptim.comreport/bar_pl/chk.fcgi\u{0a}"))))
; e2give\.com.*Login\s+adfsgecoiwnf\u{23}\u{23}\u{23}\u{23}User-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "e2give.com") (re.* re.allchar) (str.to_re "Login") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "adfsgecoiwnf\u{1b}####User-Agent:\u{0a}"))))
(check-sat)
