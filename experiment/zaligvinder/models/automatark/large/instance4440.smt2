(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^Host\u{3a}[^\u{0d}\u{0a}]+\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\u{3a}\d{1,5}\u{0d}?$/mi
(assert (not (str.in_re X (re.++ (str.to_re "/Host:") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")) (re.opt (str.to_re "\u{0d}")) (str.to_re "/mi\u{0a}")))))
; /filename=[^\n]*\u{2e}cis/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".cis/i\u{0a}"))))
; /^\u{2f}[0-9A-F]{42}$/Um
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 42 42) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/Um\u{0a}")))))
(check-sat)
