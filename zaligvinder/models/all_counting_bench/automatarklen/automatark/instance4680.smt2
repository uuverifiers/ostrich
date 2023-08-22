(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /SOAPAction\x3A\s*?\u{22}[^\u{22}\u{23}]+?\u{23}([^\u{22}]{2048}|[^\u{22}]+$)/Hsi
(assert (not (str.in_re X (re.++ (str.to_re "/SOAPAction:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}") (re.+ (re.union (str.to_re "\u{22}") (str.to_re "#"))) (str.to_re "#") (re.union ((_ re.loop 2048 2048) (re.comp (str.to_re "\u{22}"))) (re.+ (re.comp (str.to_re "\u{22}")))) (str.to_re "/Hsi\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
