(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+\.ico\s+Host\x3Aorigin\x3Dsidefind
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".ico") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:origin=sidefind\u{0a}"))))
; /\u{2e}slk([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.slk") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /\u{2e}tif(f)?([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.tif") (re.opt (str.to_re "f")) (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /\u{02}[^\u{0a}]+\u{3a}[^\u{0a}]+\u{0a}/
(assert (str.in_re X (re.++ (str.to_re "/\u{02}") (re.+ (re.comp (str.to_re "\u{0a}"))) (str.to_re ":") (re.+ (re.comp (str.to_re "\u{0a}"))) (str.to_re "\u{0a}/\u{0a}"))))
; (^\d{3,5}\,\d{2}$)|(^\d{3,5}$)
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 3 5) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 3 5) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
