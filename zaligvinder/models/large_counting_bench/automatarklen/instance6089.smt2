(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; corep\x2Edmcast\x2Ecom\s+FunWebProducts\w+searchreslt\x7D\x7BSysuptime\x3ASubject\x3AHANDY
(assert (str.in_re X (re.++ (str.to_re "corep.dmcast.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "FunWebProducts") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "searchreslt}{Sysuptime:Subject:HANDY\u{0a}"))))
; /User-Agent\u{3a}\u{20}[^\u{0d}\u{0a}]*?\u{3b}U\u{3a}[^\u{0d}\u{0a}]{1,68}\u{3b}rv\u{3a}/H
(assert (str.in_re X (re.++ (str.to_re "/User-Agent: ") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ";U:") ((_ re.loop 1 68) (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ";rv:/H\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
