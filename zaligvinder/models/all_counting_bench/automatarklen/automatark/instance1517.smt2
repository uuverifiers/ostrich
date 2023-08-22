(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{00}{7}\u{55}\u{00}{3}\u{21}.{4}[^\u{00}]*?[\u{22}\u{27}\u{29}\u{3b}]/
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 7 7) (str.to_re "\u{00}")) (str.to_re "U") ((_ re.loop 3 3) (str.to_re "\u{00}")) (str.to_re "!") ((_ re.loop 4 4) re.allchar) (re.* (re.comp (str.to_re "\u{00}"))) (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ")") (str.to_re ";")) (str.to_re "/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
