(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\d{5}\x2D\d{3}$)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9"))))))
; /\u{2e}png([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.png") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /^\/load\.php\?spl=[^&]+&b=[^&]+&o=[^&]+&i=/U
(assert (str.in_re X (re.++ (str.to_re "//load.php?spl=") (re.+ (re.comp (str.to_re "&"))) (str.to_re "&b=") (re.+ (re.comp (str.to_re "&"))) (str.to_re "&o=") (re.+ (re.comp (str.to_re "&"))) (str.to_re "&i=/U\u{0a}"))))
(check-sat)
