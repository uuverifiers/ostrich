(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[D-d][K-k]( |-)[1-9]{1}[0-9]{3}$
(assert (not (str.in_re X (re.++ (re.range "D" "d") (re.range "K" "k") (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Hours\w+User-Agent\x3AChildWebGuardian
(assert (str.in_re X (re.++ (str.to_re "Hours") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "User-Agent:ChildWebGuardian\u{0a}"))))
; /\u{2e}m3u([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.m3u") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^(\w+)s?\:\/\/(\w+)?(\.)?(\w+)?\.(\w+)$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re "s")) (str.to_re "://") (re.opt (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.opt (str.to_re ".")) (re.opt (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (str.to_re ".") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
