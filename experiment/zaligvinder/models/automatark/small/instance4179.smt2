(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x5D\u{25}20\x5BPort_\d+TM_SEARCH3engineto=\x2Fezsb\s\x3A
(assert (not (str.in_re X (re.++ (str.to_re "]%20[Port_") (re.+ (re.range "0" "9")) (str.to_re "TM_SEARCH3engineto=/ezsb") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re ":\u{0a}")))))
; ^\d{3}-\d{2}-\d{4}$
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; URLUBAgent%3fSchwindlerurl=Host\u{3a}httpUser-Agent\x3A
(assert (str.in_re X (str.to_re "URLUBAgent%3fSchwindlerurl=Host:httpUser-Agent:\u{0a}")))
; DmInf\x5E\x0D\x0A\x0D\x0AAttached\x2Fbar_pl\x2Fchk\.fcgi
(assert (not (str.in_re X (str.to_re "DmInf^\u{0d}\u{0a}\u{0d}\u{0a}Attached/bar_pl/chk.fcgi\u{0a}"))))
(check-sat)
