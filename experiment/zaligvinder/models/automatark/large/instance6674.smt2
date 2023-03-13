(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[^\\\./:\*\?\"<>\|]{1}[^\\/:\*\?\"<>\|]{0,254}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "\u{5c}") (str.to_re ".") (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) ((_ re.loop 0 254) (re.union (str.to_re "\u{5c}") (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (str.to_re "\u{0a}")))))
; pgwtjgxwthx\u{2f}byb\.xkyLOGurl=enews\x2Eearthlink\x2Enet
(assert (not (str.in_re X (str.to_re "pgwtjgxwthx/byb.xkyLOGurl=enews.earthlink.net\u{0a}"))))
; InformationHost\x3Abadurl\x2Egrandstreetinteractive\x2Ecom
(assert (str.in_re X (str.to_re "InformationHost:badurl.grandstreetinteractive.com\u{0a}")))
(check-sat)
