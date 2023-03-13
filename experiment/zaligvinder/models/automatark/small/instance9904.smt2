(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /(sIda\/sId|urua\/uru)[abcd]\.classPK/ims
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "sIda/sId") (str.to_re "urua/uru")) (re.union (str.to_re "a") (str.to_re "b") (str.to_re "c") (str.to_re "d")) (str.to_re ".classPK/ims\u{0a}"))))
; Server.*Host\u{3a}.*SpyAgentRootHost\x3A
(assert (str.in_re X (re.++ (str.to_re "Server") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "SpyAgentRootHost:\u{0a}"))))
; ^\$(\d{1,3}(\,\d{3})*|(\d+))(\.\d{2})?$
(assert (str.in_re X (re.++ (str.to_re "$") (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.+ (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(check-sat)
