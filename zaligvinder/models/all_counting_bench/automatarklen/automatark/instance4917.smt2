(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^dataget\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (not (str.in_re X (re.++ (str.to_re "/dataget|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}")))))
; ^\d*\.?\d*$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Travel.*www\x2Etopadwarereviews\x2Ecom\s+v2\x2E0www\.raxsearch\.com
(assert (str.in_re X (re.++ (str.to_re "Travel") (re.* re.allchar) (str.to_re "www.topadwarereviews.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "v2.0www.raxsearch.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
