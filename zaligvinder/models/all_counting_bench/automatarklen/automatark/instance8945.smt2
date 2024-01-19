(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; A-311www3\.addfreestats\.comAttachedX-Mailer\x3A
(assert (not (str.in_re X (str.to_re "A-311www3.addfreestats.comAttachedX-Mailer:\u{13}\u{0a}"))))
; ^(0?[1-9]|1[012])/([012][0-9]|[1-9]|3[01])/([12][0-9]{3})$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (str.to_re "/") (re.union (re.++ (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.range "1" "9") (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "/\u{0a}") (re.union (str.to_re "1") (str.to_re "2")) ((_ re.loop 3 3) (re.range "0" "9")))))
; information\s+User-Agent\x3AMM_RECO\x2EEXE
(assert (not (str.in_re X (re.++ (str.to_re "information") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:MM_RECO.EXE\u{0a}")))))
; Minutes\s+\x2Fcgi\x2Flogurl\.cgi\s+e2give\.com
(assert (not (str.in_re X (re.++ (str.to_re "Minutes") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/cgi/logurl.cgi") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "e2give.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
