(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}pac([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.pac") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^[1-9][0-9]{0,6}(|.[0-9]{1,2}|,[0-9]{1,2})?
(assert (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 0 6) (re.range "0" "9")) (re.opt (re.union (re.++ re.allchar ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (str.to_re ",") ((_ re.loop 1 2) (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
