(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\-)?1000([.][0]{1,3})?$|^(\-)?\d{1,3}$|^(\-)?\d{1,3}([.]\d{1,3})$|^(\-)?([.]\d{1,3})$
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "-")) (str.to_re "1000") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (str.to_re "0"))))) (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 3) (re.range "0" "9"))) (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))) (re.++ (re.opt (str.to_re "-")) (str.to_re "\u{0a}.") ((_ re.loop 1 3) (re.range "0" "9"))))))
; /^\+?([0-9]{2})\)?[-. ]?([0-9]{4})[-. ]?([0-9]{4})$/;
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.opt (str.to_re "+")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/;\u{0a}")))))
; \x2Fcgi\x2Flogurl\.cgi\s+Host\x3AUser-Agent\x3ASurveillancecom
(assert (str.in_re X (re.++ (str.to_re "/cgi/logurl.cgi") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:User-Agent:Surveillance\u{13}com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
