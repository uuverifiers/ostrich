(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\+[0-9]{1,3}\.[0-9]+\.[0-9]+$
(assert (not (str.in_re X (re.++ (str.to_re "+") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Host\u{3a}\s+is\s+User-Agent\x3Acid=tb\u{2e}Cookie\x3A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "is") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:cid=tb.Cookie:\u{0a}"))))
(check-sat)
