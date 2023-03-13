(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (CZ-?)?[0-9]{8,10}
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "CZ") (re.opt (str.to_re "-")))) ((_ re.loop 8 10) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; \x2Fcgi\x2Flogurl\.cgi\s+Host\x3AUser-Agent\x3ASurveillancecom
(assert (not (str.in_re X (re.++ (str.to_re "/cgi/logurl.cgi") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:User-Agent:Surveillance\u{13}com\u{0a}")))))
(check-sat)
