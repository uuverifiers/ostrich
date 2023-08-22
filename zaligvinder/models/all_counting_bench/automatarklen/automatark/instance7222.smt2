(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{28}\u{3f}\u{3d}[^)]{300}/
(assert (str.in_re X (re.++ (str.to_re "/(?=") ((_ re.loop 300 300) (re.comp (str.to_re ")"))) (str.to_re "/\u{0a}"))))
; CommonName.*st=\s+Contactfrom=GhostVoiceServerUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "CommonName") (re.* re.allchar) (str.to_re "st=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Contactfrom=GhostVoiceServerUser-Agent:\u{0a}"))))
; /filename=[^\n]*\u{2e}sln/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".sln/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
