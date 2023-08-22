(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}torrent([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.torrent") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^((\d{1,3}((,\d{3})*|\d*)(\.{0,1})\d+)|\d+)$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.union (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))) (re.* (re.range "0" "9"))) (re.opt (str.to_re ".")) (re.+ (re.range "0" "9"))) (re.+ (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
