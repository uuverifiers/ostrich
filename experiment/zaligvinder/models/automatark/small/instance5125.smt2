(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[ABCGHJMPQRTWXYZ]$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "A") (str.to_re "B") (str.to_re "C") (str.to_re "G") (str.to_re "H") (str.to_re "J") (str.to_re "M") (str.to_re "P") (str.to_re "Q") (str.to_re "R") (str.to_re "T") (str.to_re "W") (str.to_re "X") (str.to_re "Y") (str.to_re "Z")) (str.to_re "\u{0a}")))))
; ^([A-Z]{2}[9]{3}|[A-Z]{3}[9]{2}|[A-Z]{4}[9]{1}|[A-Z]{5})[0-9]{6}([A-Z]{1}[9]{1}|[A-Z]{2})[A-Z0,9]{3}$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 3 3) (str.to_re "9"))) (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) ((_ re.loop 2 2) (str.to_re "9"))) (re.++ ((_ re.loop 4 4) (re.range "A" "Z")) ((_ re.loop 1 1) (str.to_re "9"))) ((_ re.loop 5 5) (re.range "A" "Z"))) ((_ re.loop 6 6) (re.range "0" "9")) (re.union (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 1) (str.to_re "9"))) ((_ re.loop 2 2) (re.range "A" "Z"))) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (str.to_re "0") (str.to_re ",") (str.to_re "9"))) (str.to_re "\u{0a}")))))
; /\u{2e}htc([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.htc") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; zmnjgmomgbdz\u{2f}zzmw\.gzt\d+Ready
(assert (not (str.in_re X (re.++ (str.to_re "zmnjgmomgbdz/zzmw.gzt") (re.+ (re.range "0" "9")) (str.to_re "Ready\u{0a}")))))
; /\u{2e}flv([\?\u{5c}\u{2f}]|$)/Umsi
(assert (not (str.in_re X (re.++ (str.to_re "/.flv") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/Umsi\u{0a}")))))
(check-sat)
