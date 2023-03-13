(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^100$|^\s*(\d{0,2})((\.|\,)(\d*))?\s*\%?\s*$
(assert (str.in_re X (re.union (str.to_re "100") (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) (re.* (re.range "0" "9")))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "%")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; Host\x3A\d+ver\d+sportsUBAgent
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "ver") (re.+ (re.range "0" "9")) (str.to_re "sportsUBAgent\u{0a}")))))
; ^([\d]*[1-9]+[\d]*)$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))))))
(check-sat)
