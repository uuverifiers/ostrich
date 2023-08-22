(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(F-)?((2[A|B])|[0-9]{2})[0-9]{3}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "F-")) (re.union (re.++ (str.to_re "2") (re.union (str.to_re "A") (str.to_re "|") (str.to_re "B"))) ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Spy\dccecaedbebfcaf\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Spy") (re.range "0" "9") (str.to_re "ccecaedbebfcaf.com\u{0a}"))))
; SpyBuddyZOMBIES\u{5f}HTTP\u{5f}GETearch\x2Eearthlink
(assert (str.in_re X (str.to_re "SpyBuddyZOMBIES_HTTP_GETearch.earthlink\u{0a}")))
; /\u{2e}mov([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.mov") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^((((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)))\s*([,;]|$)+\s*)*$
(assert (not (str.in_re X (re.++ (re.* (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (str.to_re ",") (str.to_re ";"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9")))) (str.to_re ".") (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9")))) (str.to_re ".") (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9")))) (str.to_re ".") (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
