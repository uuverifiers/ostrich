(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \u{22}The\s+e2give\.com\s+NETObserve
(assert (str.in_re X (re.++ (str.to_re "\u{22}The") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "e2give.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "NETObserve\u{0a}"))))
; /\u{2f}(css|upload)\u{2f}[a-z]{2}[0-9]{3}\u{2e}ccs/U
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.union (str.to_re "css") (str.to_re "upload")) (str.to_re "/") ((_ re.loop 2 2) (re.range "a" "z")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".ccs/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
