(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SbAts[^\n\r]*Subject\u{3a}\d+dcww\x2Edmcast\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "SbAts") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Subject:") (re.+ (re.range "0" "9")) (str.to_re "dcww.dmcast.com\u{0a}")))))
; Try2Find\u{23}\u{23}\u{23}\u{23}ToolbarServerUser\x3A
(assert (str.in_re X (str.to_re "Try2Find####ToolbarServerUser:\u{0a}")))
; /^\/[a-z]{2,20}\.php\?[a-z]{2,10}\u{3d}[a-zA-Z0-9\u{2f}\u{2b}]+\u{3d}$/I
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 2 20) (re.range "a" "z")) (str.to_re ".php?") ((_ re.loop 2 10) (re.range "a" "z")) (str.to_re "=") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "/") (str.to_re "+"))) (str.to_re "=/I\u{0a}")))))
(check-sat)
