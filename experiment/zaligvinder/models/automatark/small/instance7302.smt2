(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\d{1,9})+(,\d{1,9})*$
(assert (str.in_re X (re.++ (re.+ ((_ re.loop 1 9) (re.range "0" "9"))) (re.* (re.++ (str.to_re ",") ((_ re.loop 1 9) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; www\.actualnames\.com\s+toolbar_domain_redirect\s+Contactfrom=GhostVoiceServer
(assert (str.in_re X (re.++ (str.to_re "www.actualnames.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "toolbar_domain_redirect") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Contactfrom=GhostVoiceServer\u{0a}"))))
(check-sat)
