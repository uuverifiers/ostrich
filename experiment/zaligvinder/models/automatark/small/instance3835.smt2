(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}xbm([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.xbm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ed2k\u{c0}STATUS\u{c0}Server\x7D\x7BPort\x3Ahttp\x3A\x2F\x2Ftv\x2Eseekmo\x2Ecom\x2Fshowme\x2Easpx\x3Fkeyword=
(assert (not (str.in_re X (str.to_re "ed2k\u{c0}STATUS\u{c0}Server\u{13}}{Port:http://tv.seekmo.com/showme.aspx?keyword=\u{0a}"))))
; ^(3[0-1]|2[0-9]|1[0-9]|0[1-9])(0[0-9]|1[0-9]|2[0-3])([0-5][0-9])\sUTC\s(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s[0-9]{2}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "3") (re.range "0" "1")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "0") (re.range "1" "9"))) (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "UTC") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (str.to_re "Jan") (str.to_re "Feb") (str.to_re "Mar") (str.to_re "Apr") (str.to_re "May") (str.to_re "Jun") (str.to_re "Jul") (str.to_re "Aug") (str.to_re "Sep") (str.to_re "Oct") (str.to_re "Nov") (str.to_re "Dec")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}") (re.range "0" "5") (re.range "0" "9")))))
; /^GET\u{20}\/plus\u{2e}asp\?[^\r\n]*?query=[a-z0-9+\/]{2,40}@{0,2}/i
(assert (str.in_re X (re.++ (str.to_re "/GET /plus.asp?") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "query=") ((_ re.loop 2 40) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) ((_ re.loop 0 2) (str.to_re "@")) (str.to_re "/i\u{0a}"))))
; /m.php\?do=(getvers|status|getcmd)/Ui
(assert (str.in_re X (re.++ (str.to_re "/m") re.allchar (str.to_re "php?do=") (re.union (str.to_re "getvers") (str.to_re "status") (str.to_re "getcmd")) (str.to_re "/Ui\u{0a}"))))
(check-sat)
