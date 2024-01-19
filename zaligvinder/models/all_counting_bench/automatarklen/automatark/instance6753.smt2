(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Z]{1,2}[0-9]{1,2}|[A-Z]{3}|[A-Z]{1,2}[0-9][A-Z])( |-)[0-9][A-Z]{2}
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) ((_ re.loop 1 2) (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "A" "Z")) (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) (re.range "0" "9") (re.range "A" "Z"))) (re.union (str.to_re " ") (str.to_re "-")) (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}")))))
; ^A-?|[BCD][+-]?|[SN]?F|W$
(assert (not (str.in_re X (re.union (re.++ (str.to_re "A") (re.opt (str.to_re "-"))) (re.++ (re.union (str.to_re "B") (str.to_re "C") (str.to_re "D")) (re.opt (re.union (str.to_re "+") (str.to_re "-")))) (re.++ (re.opt (re.union (str.to_re "S") (str.to_re "N"))) (str.to_re "F")) (str.to_re "W\u{0a}")))))
; zmnjgmomgbdz\u{2f}zzmw\.gzt\d+Ready
(assert (not (str.in_re X (re.++ (str.to_re "zmnjgmomgbdz/zzmw.gzt") (re.+ (re.range "0" "9")) (str.to_re "Ready\u{0a}")))))
; ^\d+(\.\d+)?$
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; fhfksjzsfu\u{2f}ahm\.uqs\s+Host\u{3a}\swww\.fast-finder\.com\sStarted\!$3
(assert (str.in_re X (re.++ (str.to_re "fhfksjzsfu/ahm.uqs") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.fast-finder.com") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Started!3\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
