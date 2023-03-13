(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Frss\d+answer\sHost\x3A
(assert (str.in_re X (re.++ (str.to_re "/rss") (re.+ (re.range "0" "9")) (str.to_re "answer") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:\u{0a}"))))
; /\u{2e}mp3([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.mp3") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /^\/amor\d{0,2}\.jar/U
(assert (not (str.in_re X (re.++ (str.to_re "//amor") ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re ".jar/U\u{0a}")))))
; ^[a-zA-Z0-9]+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; [0-9]{4}-[0-9]{3}
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
