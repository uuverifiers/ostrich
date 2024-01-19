(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (.*)-----(BEGIN|END)([^-]*)-----(.*)
(assert (not (str.in_re X (re.++ (re.* re.allchar) (str.to_re "-----") (re.union (str.to_re "BEGIN") (str.to_re "END")) (re.* (re.comp (str.to_re "-"))) (str.to_re "-----") (re.* re.allchar) (str.to_re "\u{0a}")))))
; uuid=\s+User-Agent\u{3a}\d+\x5Chome\/lordofsearch
(assert (not (str.in_re X (re.++ (str.to_re "uuid=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "\u{5c}home/lordofsearch\u{0a}")))))
; ^\d{3}\s?\d{3}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
