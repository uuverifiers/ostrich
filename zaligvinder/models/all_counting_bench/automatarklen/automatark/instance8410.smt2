(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\.background\s*=\s*[\u{22}\u{27}]{2}/i
(assert (str.in_re X (re.++ (str.to_re "/.background") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "/i\u{0a}"))))
; @([_a-zA-Z]+)
(assert (not (str.in_re X (re.++ (str.to_re "@") (re.+ (re.union (str.to_re "_") (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; Host\x3Ahjhgquqssq\u{2f}pjmonHost\x3AHost\x3AA-311byName=Your\+Host\+is\x3A
(assert (str.in_re X (str.to_re "Host:hjhgquqssq/pjmonHost:Host:A-311byName=Your+Host+is:\u{0a}")))
; Host\x3A\d+Litequick\x2Eqsrch\x2EcomaboutHost\x3AComputer\x7D\x7BSysuptime\x3A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Litequick.qsrch.comaboutHost:Computer}{Sysuptime:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
