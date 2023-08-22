(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\.background\s*=\s*[\u{22}\u{27}]{2}/i
(assert (not (str.in_re X (re.++ (str.to_re "/.background") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "/i\u{0a}")))))
; /\u{2e}qt([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.qt") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; Referer\x3A\s+www\u{2e}proventactics\u{2e}com
(assert (str.in_re X (re.++ (str.to_re "Referer:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.proventactics.com\u{0a}"))))
; vb\s+Host\x3ASubject\x3Aonline-casino-searcher\.com
(assert (str.in_re X (re.++ (str.to_re "vb") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Subject:online-casino-searcher.com\u{0a}"))))
; ((\(\d{2}\) ?)|(\d{2}/))?\d{2}/\d{4} ([0-2][0-9]\:[0-6][0-9])
(assert (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "(") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " "))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/")))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " \u{0a}") (re.range "0" "2") (re.range "0" "9") (str.to_re ":") (re.range "0" "6") (re.range "0" "9"))))
(assert (> (str.len X) 10))
(check-sat)
