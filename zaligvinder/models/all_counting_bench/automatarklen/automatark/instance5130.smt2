(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Everyware.*Email.*Host\x3Astepwww\x2Ekornputers\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Everyware") (re.* re.allchar) (str.to_re "Email") (re.* re.allchar) (str.to_re "Host:stepwww.kornputers.com\u{0a}"))))
; uuid=\s+User-Agent\u{3a}\d+\x5Chome\/lordofsearch
(assert (not (str.in_re X (re.++ (str.to_re "uuid=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "\u{5c}home/lordofsearch\u{0a}")))))
; ^([A-z]{2}\d{9}[Gg][Bb])|(\d{12})$
(assert (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.range "A" "z")) ((_ re.loop 9 9) (re.range "0" "9")) (re.union (str.to_re "G") (str.to_re "g")) (re.union (str.to_re "B") (str.to_re "b"))) (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
