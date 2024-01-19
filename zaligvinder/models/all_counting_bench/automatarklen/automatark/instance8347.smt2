(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b[A-Z0-9]{5}\d{1}[01567]\d{1}([0][1-9]|[12][0-9]|[3][0-1])\d{1}[A-Z0-9]{3}[A-Z]{2}\b
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 1 1) (re.range "0" "9")) (re.union (str.to_re "0") (str.to_re "1") (str.to_re "5") (str.to_re "6") (str.to_re "7")) ((_ re.loop 1 1) (re.range "0" "9")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}ppt/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ppt/i\u{0a}"))))
; $(\n|\r\n)
(assert (str.in_re X (re.++ (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}\u{0a}")) (str.to_re "\u{0a}"))))
; /\u{2e}s3m([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.s3m") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^(0|1)+$
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "0") (str.to_re "1"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
