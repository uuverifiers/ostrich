(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((0?[1-9])|((1)[0-1]))?((\.[0-9]{0,2})?|0(\.[0-9]{0,2}))$
(assert (not (str.in_re X (re.++ (re.opt (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "1")))) (re.union (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))) (re.++ (str.to_re "0.") ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^(0{1})([1-9]{2})(\s|-|.{0,1})(\d{3})(\s|-|.{0,1})(\d{2})(\s|-|.{0,1})(\d{2})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "0")) ((_ re.loop 2 2) (re.range "1" "9")) (re.union (str.to_re "-") (re.opt re.allchar) (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (re.opt re.allchar) (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re "-") (re.opt re.allchar) (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \x2Fcgi\x2Flogurl\.cgi\s+Host\x3AUser-Agent\x3ASurveillancecom
(assert (str.in_re X (re.++ (str.to_re "/cgi/logurl.cgi") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:User-Agent:Surveillance\u{13}com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
