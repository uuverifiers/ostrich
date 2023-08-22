(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /nim:import\?[^\u{22}\u{27}>\s]*?filename=[^\u{22}\u{27}>\s]{485}/i
(assert (not (str.in_re X (re.++ (str.to_re "/nim:import?") (re.* (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "filename=") ((_ re.loop 485 485) (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
