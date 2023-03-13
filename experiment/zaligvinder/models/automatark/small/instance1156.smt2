(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+Subject\u{3a}Host\x3A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Subject:Host:\u{0a}"))))
; /\u{00}{7}\u{53}\u{00}{3}\u{16}.{8}[^\u{00}]*?[\u{22}\u{27}\u{29}\u{3b}]/
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 7 7) (str.to_re "\u{00}")) (str.to_re "S") ((_ re.loop 3 3) (str.to_re "\u{00}")) (str.to_re "\u{16}") ((_ re.loop 8 8) re.allchar) (re.* (re.comp (str.to_re "\u{00}"))) (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ")") (str.to_re ";")) (str.to_re "/\u{0a}"))))
(check-sat)
