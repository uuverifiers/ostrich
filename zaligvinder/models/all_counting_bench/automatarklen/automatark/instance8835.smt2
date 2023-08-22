(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[-|\+]?[0-9]{1,3}(\,[0-9]{3})*$|^[-|\+]?[0-9]+$
(assert (not (str.in_re X (re.union (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "|") (str.to_re "+"))) ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "|") (str.to_re "+"))) (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; NetTracker\.htaServerTheef2trustyfiles\x2EcomlogsHost\x3Aversion
(assert (str.in_re X (str.to_re "NetTracker.htaServerTheef2trustyfiles.comlogsHost:version\u{0a}")))
; /\u{2e}jpeg([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.jpeg") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
