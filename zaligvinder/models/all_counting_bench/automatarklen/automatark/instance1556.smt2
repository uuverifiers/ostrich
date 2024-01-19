(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}vsd/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".vsd/i\u{0a}"))))
; /filename=[^\n]*\u{2e}asx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".asx/i\u{0a}")))))
; Minutes\s+\x2Fcgi\x2Flogurl\.cgi\s+e2give\.com
(assert (not (str.in_re X (re.++ (str.to_re "Minutes") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/cgi/logurl.cgi") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "e2give.com\u{0a}")))))
; ^(0?[1-9]|[12][0-9]|3[01])[- /.](0?[1-9]|1[012])[- /.](19|20)?[0-9]{2}? ?((([0-1]?\d)|(2[0-3])):[0-5]\d)?(:[0-5]\d)? ?([a,p,A,P][m,M])?$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "/") (str.to_re ".")) (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "/") (str.to_re ".")) (re.opt (re.union (str.to_re "19") (str.to_re "20"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) (re.opt (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (re.opt (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (re.opt (str.to_re " ")) (re.opt (re.++ (re.union (str.to_re "a") (str.to_re ",") (str.to_re "p") (str.to_re "A") (str.to_re "P")) (re.union (str.to_re "m") (str.to_re ",") (str.to_re "M")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
