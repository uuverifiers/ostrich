(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-2]?[1-9]{1}$|^3{1}[01]{1}$
(assert (not (str.in_re X (re.union (re.++ (re.opt (re.range "0" "2")) ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "3")) ((_ re.loop 1 1) (re.union (str.to_re "0") (str.to_re "1"))) (str.to_re "\u{0a}"))))))
; Host\x3A\d+rprpgbnrppb\u{2f}ci[^\n\r]*RXFilteredDmInf\x5E
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "rprpgbnrppb/ci") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "RXFilteredDmInf^\u{0a}"))))
; ^(\(?\+?[0-9]*\)?)?[0-9_\- \(\)]*$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "(")) (re.opt (str.to_re "+")) (re.* (re.range "0" "9")) (re.opt (str.to_re ")")))) (re.* (re.union (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re " ") (str.to_re "(") (str.to_re ")"))) (str.to_re "\u{0a}")))))
; www\x2Ewebcruiser\x2Eccgot
(assert (not (str.in_re X (str.to_re "www.webcruiser.ccgot\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
