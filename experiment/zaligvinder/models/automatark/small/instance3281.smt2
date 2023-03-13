(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; replace(MobileNo,' ',''),'^(\+44|0044|0)(7)[4-9][0-9]{8}$'
(assert (str.in_re X (re.++ (str.to_re "replaceMobileNo,' ','','") (re.union (str.to_re "+44") (str.to_re "0044") (str.to_re "0")) (str.to_re "7") (re.range "4" "9") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "'\u{0a}"))))
; /\x2Ermf([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.rmf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; Host\x3Ahirmvtg\u{2f}ggqh\.kqhverA-Spy
(assert (str.in_re X (str.to_re "Host:hirmvtg/ggqh.kqh\u{1b}verA-Spy\u{0a}")))
; Referer\x3Awww\x2Eccnnlc\x2Ecom\u{04}\u{00}User-Agent\x3A\u{22}The
(assert (str.in_re X (str.to_re "Referer:www.ccnnlc.com\u{13}\u{04}\u{00}User-Agent:\u{22}The\u{0a}")))
(check-sat)
