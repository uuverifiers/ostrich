(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A.*Basic.*ProtoUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "Basic") (re.* re.allchar) (str.to_re "ProtoUser-Agent:\u{0a}"))))
; /^(\u{75}|\u{2d}|\u{2f}|\u{73}|\u{a2}|\u{2e}|\u{24}|\u{74})/sR
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "u") (str.to_re "-") (str.to_re "/") (str.to_re "s") (str.to_re "\u{a2}") (str.to_re ".") (str.to_re "$") (str.to_re "t")) (str.to_re "/sR\u{0a}")))))
; ([+]?\d[ ]?[(]?\d{3}[)]?[ ]?\d{2,3}[- ]?\d{2}[- ]?\d{2})
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "+")) (re.range "0" "9") (re.opt (str.to_re " ")) (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (str.to_re " ")) ((_ re.loop 2 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 2 2) (re.range "0" "9")))))
; /\u{2e}hlp([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.hlp") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; engineResultUser-Agent\x3A
(assert (str.in_re X (str.to_re "engineResultUser-Agent:\u{0a}")))
(check-sat)
