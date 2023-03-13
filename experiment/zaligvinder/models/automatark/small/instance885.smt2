(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{00}{7}\u{53}\u{00}{3}\u{16}.{8}[^\u{00}]*?[\u{22}\u{27}\u{29}\u{3b}]/
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 7 7) (str.to_re "\u{00}")) (str.to_re "S") ((_ re.loop 3 3) (str.to_re "\u{00}")) (str.to_re "\u{16}") ((_ re.loop 8 8) re.allchar) (re.* (re.comp (str.to_re "\u{00}"))) (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ")") (str.to_re ";")) (str.to_re "/\u{0a}")))))
; /\u{2e}rt([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.rt") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(check-sat)
