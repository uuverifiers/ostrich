(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((\(\d{3}\)|\d{3})( |-|\.))|(\(\d{3}\)|\d{3}))?\d{3}( |-|\.)?\d{4}(( |-|\.)?([Ee]xt|[Xx])[.]?( |-|\.)?\d{4})?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (re.++ (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.union (str.to_re " ") (str.to_re "-") (str.to_re "."))) (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 3 3) (re.range "0" "9")))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "."))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "."))) (re.union (re.++ (re.union (str.to_re "E") (str.to_re "e")) (str.to_re "xt")) (str.to_re "X") (str.to_re "x")) (re.opt (str.to_re ".")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "."))) ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; www\x2EZSearchResults\x2Ecom\dBar.*sponsor2\.ucmore\.com
(assert (str.in_re X (re.++ (str.to_re "www.ZSearchResults.com\u{13}") (re.range "0" "9") (str.to_re "Bar") (re.* re.allchar) (str.to_re "sponsor2.ucmore.com\u{0a}"))))
; /\u{2e}kvl([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.kvl") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; \.exe\s+v2\x2E0\s+smrtshpr-cs-
(assert (str.in_re X (re.++ (str.to_re ".exe") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "v2.0") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "smrtshpr-cs-\u{13}\u{0a}"))))
(check-sat)
