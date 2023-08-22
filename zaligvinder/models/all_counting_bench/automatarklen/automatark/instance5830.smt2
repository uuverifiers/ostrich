(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^~/[0-9a-zA-Z_][0-9a-zA-Z/_-]*\.[0-9a-zA-Z_-]+$
(assert (not (str.in_re X (re.++ (str.to_re "~/") (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_")) (re.* (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "/") (str.to_re "_") (str.to_re "-"))) (str.to_re ".") (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re "-"))) (str.to_re "\u{0a}")))))
; ^[\d]{5}[-\s]{1}[\d]{3}[-\s]{1}[\d]{3}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /^UPDATE\|[0-9]\.[0-9]\.[0-9]\|[A-F0-9]{48}\|{3}$/
(assert (not (str.in_re X (re.++ (str.to_re "/UPDATE|") (re.range "0" "9") (str.to_re ".") (re.range "0" "9") (str.to_re ".") (re.range "0" "9") (str.to_re "|") ((_ re.loop 48 48) (re.union (re.range "A" "F") (re.range "0" "9"))) ((_ re.loop 3 3) (str.to_re "|")) (str.to_re "/\u{0a}")))))
; /\u{2e}spx([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.spx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; \x2Frss\d+answer\sHost\x3A
(assert (str.in_re X (re.++ (str.to_re "/rss") (re.+ (re.range "0" "9")) (str.to_re "answer") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
