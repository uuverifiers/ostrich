(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^dir=[0-9A-F]{8}(-[0-9A-F]{4}){4}[0-9A-F]{8}&data=/Pi
(assert (not (str.in_re X (re.++ (str.to_re "/dir=") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "F"))) ((_ re.loop 4 4) (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))))) ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "&data=/Pi\u{0a}")))))
; Subject\x3AUser-Agent\x3AiebarSubject\x3A
(assert (str.in_re X (str.to_re "Subject:User-Agent:iebarSubject:\u{0a}")))
; [^"]+
(assert (str.in_re X (re.++ (re.+ (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{0a}"))))
; ^((0[1-9])|(1[0-2]))\/*((2011)|(20[1-9][1-9]))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.* (str.to_re "/")) (re.union (str.to_re "2011") (re.++ (str.to_re "20") (re.range "1" "9") (re.range "1" "9"))) (str.to_re "\u{0a}")))))
; /\u{2e}pct([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.pct") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
