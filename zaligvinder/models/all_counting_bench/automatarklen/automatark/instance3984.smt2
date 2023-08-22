(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Ehtml\s+IDENTIFYwww\x2Eccnnlc\x2Ecomfilename=\u{22}Referer\x3A
(assert (str.in_re X (re.++ (str.to_re ".html") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "IDENTIFYwww.ccnnlc.com\u{13}filename=\u{22}Referer:\u{0a}"))))
; Host\x3A[^\n\r]*cache\x2Eeverer\x2Ecom\s+from\.myway\.comToolbar
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "cache.everer.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "from.myway.com\u{1b}Toolbar\u{0a}")))))
; ^\d{8,8}$|^[SC]{2,2}\d{6,6}$
(assert (not (str.in_re X (re.union ((_ re.loop 8 8) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "S") (str.to_re "C"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; EFError.*Host\x3A\swww\u{2e}malware-stopper\u{2e}com
(assert (not (str.in_re X (re.++ (str.to_re "EFError") (re.* re.allchar) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.malware-stopper.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
