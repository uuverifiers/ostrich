(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /([etDZhns8dz]{1,3}k){3}[etDZhns8dz]{1,3}f[etDZhns8dz]{16}A/
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 3 3) (re.++ ((_ re.loop 1 3) (re.union (str.to_re "e") (str.to_re "t") (str.to_re "D") (str.to_re "Z") (str.to_re "h") (str.to_re "n") (str.to_re "s") (str.to_re "8") (str.to_re "d") (str.to_re "z"))) (str.to_re "k"))) ((_ re.loop 1 3) (re.union (str.to_re "e") (str.to_re "t") (str.to_re "D") (str.to_re "Z") (str.to_re "h") (str.to_re "n") (str.to_re "s") (str.to_re "8") (str.to_re "d") (str.to_re "z"))) (str.to_re "f") ((_ re.loop 16 16) (re.union (str.to_re "e") (str.to_re "t") (str.to_re "D") (str.to_re "Z") (str.to_re "h") (str.to_re "n") (str.to_re "s") (str.to_re "8") (str.to_re "d") (str.to_re "z"))) (str.to_re "A/\u{0a}")))))
; NavExcel\s+dist\x2Eatlas\x2Dia\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "NavExcel") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "dist.atlas-ia.com\u{0a}")))))
; \.com/(\d+)$
(assert (str.in_re X (re.++ (str.to_re ".com/") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
; www\x2Ewebcruiser\x2Eccgot
(assert (not (str.in_re X (str.to_re "www.webcruiser.ccgot\u{0a}"))))
; Minutes\s+\x2Fcgi\x2Flogurl\.cgi\s+e2give\.com
(assert (not (str.in_re X (re.++ (str.to_re "Minutes") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/cgi/logurl.cgi") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "e2give.com\u{0a}")))))
(check-sat)
