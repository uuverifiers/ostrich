(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[a-zA-Z0-9]+$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/\u{0a}"))))
; (ES-?)?([0-9A-Z][0-9]{7}[A-Z])|([A-Z][0-9]{7}[0-9A-Z])
(assert (not (str.in_re X (re.union (re.++ (re.opt (re.++ (str.to_re "ES") (re.opt (str.to_re "-")))) (re.union (re.range "0" "9") (re.range "A" "Z")) ((_ re.loop 7 7) (re.range "0" "9")) (re.range "A" "Z")) (re.++ (str.to_re "\u{0a}") (re.range "A" "Z") ((_ re.loop 7 7) (re.range "0" "9")) (re.union (re.range "0" "9") (re.range "A" "Z")))))))
; \x7D\x7BTrojan\x3AUser-Agent\x3AbyHost\x3A\u{b0}\u{ae}\u{b6}\u{f9}\u{cd}\u{f8}\u{b5}\u{c1}
(assert (not (str.in_re X (str.to_re "}{Trojan:User-Agent:byHost:\u{b0}\u{ae}\u{b6}\u{f9}\u{cd}\u{f8}\u{b5}\u{c1}\u{0a}"))))
; User-Agent\x3A\d+dll\x3F.*started\x2EfeedbackUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "dll?") (re.* re.allchar) (str.to_re "started.feedbackUser-Agent:\u{0a}")))))
; Logger.*Host\x3A.*\x2Fcommunicatortb\u{7c}roogoo\u{7c}
(assert (not (str.in_re X (re.++ (str.to_re "Logger") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "/communicatortb|roogoo|\u{0a}")))))
(check-sat)
