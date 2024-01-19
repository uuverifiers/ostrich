(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+User-Agent\x3A\s+Host\x3ADesktopBlade
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:DesktopBlade\u{0a}"))))
; (^\d{9}[V|v|x|X]$)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 9 9) (re.range "0" "9")) (re.union (str.to_re "V") (str.to_re "|") (str.to_re "v") (str.to_re "x") (str.to_re "X")))))
(assert (> (str.len X) 10))
(check-sat)
