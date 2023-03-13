(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[^_][a-zA-Z0-9_]+[^_]@{1}[a-z]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$
(assert (str.in_re X (re.++ (re.comp (str.to_re "_")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (re.comp (str.to_re "_")) ((_ re.loop 1 1) (str.to_re "@")) (re.+ (re.range "a" "z")) ((_ re.loop 1 1) (str.to_re ".")) (re.union ((_ re.loop 2 3) (re.range "a" "z")) (re.++ ((_ re.loop 2 3) (re.range "a" "z")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 3) (re.range "a" "z")))) (str.to_re "\u{0a}"))))
; /\u{2e}ogx([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.ogx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /filename=[^\n]*\u{2e}wps/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wps/i\u{0a}")))))
; \d{3}-\d{6}
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[^\u{00}-\u{1f}\u{21}-\u{26}\u{28}-\u{2d}\u{2f}-\u{40}\u{5b}-\u{60}\u{7b}-\u{ff}]+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "\u{00}" "\u{1f}") (re.range "!" "&") (re.range "(" "-") (re.range "/" "@") (re.range "[" "`") (re.range "{" "\u{ff}"))) (str.to_re "\u{0a}")))))
(check-sat)
