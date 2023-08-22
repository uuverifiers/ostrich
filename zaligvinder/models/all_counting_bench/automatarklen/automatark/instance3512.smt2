(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SpyBuddyZOMBIES\u{5f}HTTP\u{5f}GETearch\x2Eearthlink
(assert (not (str.in_re X (str.to_re "SpyBuddyZOMBIES_HTTP_GETearch.earthlink\u{0a}"))))
; /^\+?([0-9]{2})\)?[-. ]?([0-9]{4})[-. ]?([0-9]{4})$/;
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.opt (str.to_re "+")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/;\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
