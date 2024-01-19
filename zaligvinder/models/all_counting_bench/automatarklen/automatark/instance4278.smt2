(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[-+]?([0-9]{1,3}[,]?)?([0-9]{3}[,]?)*[.]?[0-9]*$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.opt (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (str.to_re ",")))) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ",")))) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Basic\s+news\s+CD\x2Furl=Host\u{3a}
(assert (str.in_re X (re.++ (str.to_re "Basic") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "news") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "CD/url=Host:\u{0a}"))))
; YWRtaW46cGFzc3dvcmQ[^\n\r]*DA[^\n\r]*Host\x3Awww\x2Ee-finder\x2Ecc
(assert (not (str.in_re X (re.++ (str.to_re "YWRtaW46cGFzc3dvcmQ") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "DA") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:www.e-finder.cc\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
