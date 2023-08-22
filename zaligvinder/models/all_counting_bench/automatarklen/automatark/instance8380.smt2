(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([0-9]{3})[-]?)*[0-9]{6,7}$
(assert (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")))) ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^(((ht|f)tp(s?))\://).*$
(assert (str.in_re X (re.++ (re.* re.allchar) (str.to_re "\u{0a}://") (re.union (str.to_re "ht") (str.to_re "f")) (str.to_re "tp") (re.opt (str.to_re "s")))))
; /^images.php\?t=\d{2,7}$/U
(assert (not (str.in_re X (re.++ (str.to_re "/images") re.allchar (str.to_re "php?t=") ((_ re.loop 2 7) (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
; named.*Host\x3A\s+zmnjgmomgbdz\u{2f}zzmw\.gzt
(assert (not (str.in_re X (re.++ (str.to_re "named") (re.* re.allchar) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "zmnjgmomgbdz/zzmw.gzt\u{0a}")))))
; /#([1-9]){2}([1-9]){2}([1-9]){2}/
(assert (not (str.in_re X (re.++ (str.to_re "/#") ((_ re.loop 2 2) (re.range "1" "9")) ((_ re.loop 2 2) (re.range "1" "9")) ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re "/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
