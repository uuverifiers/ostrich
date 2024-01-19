(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((0[1-9])|(1[0-2]))\/(([0-9])|([0-2][0-9])|(3[0-1]))/\d{2}
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.range "0" "9") (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; User-Agent\x3A[^\n\r]*quick\x2Eqsrch\x2Ecom.*www\.searchinweb\.com
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "quick.qsrch.com") (re.* re.allchar) (str.to_re "www.searchinweb.com\u{0a}"))))
; /filename=[^\n]*\u{2e}avi/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".avi/i\u{0a}"))))
; ^\s*(\d{0,2})(\.?(\d*))?\s*\%?\s*$
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (re.opt (str.to_re ".")) (re.* (re.range "0" "9")))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "%")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
