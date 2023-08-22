(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \swww\.fast-finder\.com[^\n\r]*\x2Fbar_pl\x2Fchk\.fcgi\d+Toolbar
(assert (not (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.fast-finder.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "/bar_pl/chk.fcgi") (re.+ (re.range "0" "9")) (str.to_re "Toolbar\u{0a}")))))
; ProjectHost\x3AlogHost\x3Awww\x2Esnap\x2EcomGoogle-\>rtServidor\x2E
(assert (not (str.in_re X (str.to_re "ProjectHost:logHost:www.snap.comGoogle->rtServidor.\u{13}\u{0a}"))))
; ^\d{4}(\/|-)([0][1-9]|[1][0-2])(\/|-)([0][1-9]|[1-2][0-9]|[3][0-1])$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re "/") (str.to_re "-")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (str.to_re "/") (str.to_re "-")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "\u{0a}"))))
; log\=\x7BIP\x3AReferer\x3Awww\x2Emirarsearch\x2Ecom\x2Etxte2give\.comSpywareStrikeConnectedIPSubject\x3A
(assert (not (str.in_re X (str.to_re "log={IP:Referer:www.mirarsearch.com.txte2give.comSpywareStrikeConnectedIPSubject:\u{0a}"))))
; Host\x3A[^\n\r]*cache\x2Eeverer\x2Ecom\s+from\.myway\.comToolbar
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "cache.everer.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "from.myway.com\u{1b}Toolbar\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
