(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(-?)(((\d{1,3})(,\d{3})*)|(\d+))(\.\d{1,2})?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.+ (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; cid=tb\u{2e}\s+NETObserve\s+WinSession
(assert (not (str.in_re X (re.++ (str.to_re "cid=tb.") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "NETObserve") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "WinSession\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
