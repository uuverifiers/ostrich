(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((100)|(\d{0,2}))$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "100") ((_ re.loop 0 2) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /name\u{3d}screenshot\d+\u{2e}/i
(assert (not (str.in_re X (re.++ (str.to_re "/name=screenshot") (re.+ (re.range "0" "9")) (str.to_re "./i\u{0a}")))))
; Host\x3A\s+Subject\u{3a}Host\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Subject:Host:\u{0a}")))))
; source\=IncrediFind\s+Host\x3A\s+Host\x3AHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "source=IncrediFind") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Host:\u{0a}")))))
(check-sat)
