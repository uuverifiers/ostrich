(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/3001[0-9A-F]{262,304}/
(assert (str.in_re X (re.++ (str.to_re "//3001") ((_ re.loop 262 304) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/\u{0a}"))))
; /filename=[^\n]*\u{2e}kvl/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".kvl/i\u{0a}")))))
; zmnjgmomgbdz\u{2f}zzmw\.gzt\d+Ready
(assert (str.in_re X (re.++ (str.to_re "zmnjgmomgbdz/zzmw.gzt") (re.+ (re.range "0" "9")) (str.to_re "Ready\u{0a}"))))
; (\s(\bon[a-zA-Z][a-z]+)\s?\=\s?[\'\"]?(javascript\:)?[\w\(\),\' ]*;?[\'\"]?)+
(assert (str.in_re X (re.++ (re.+ (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "'") (str.to_re "\u{22}"))) (re.opt (str.to_re "javascript:")) (re.* (re.union (str.to_re "(") (str.to_re ")") (str.to_re ",") (str.to_re "'") (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re ";")) (re.opt (re.union (str.to_re "'") (str.to_re "\u{22}"))) (str.to_re "on") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.+ (re.range "a" "z")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
